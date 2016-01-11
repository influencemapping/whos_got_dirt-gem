module WhosGotDirt
  module Validator
    class << self
      # Validates the data against the named schema and returns any errors.
      #
      # @param [Hash] data the data to validate
      # @param [String] name the name of the definition in the JSON Schema
      # @return [Array<ValidationError>] a list of validation errors
      def validate(data, name)
        validator = validators[name.downcase]
        # @see https://github.com/ruby-json-schema/json-schema/blob/fa316dc9d39b922935aed8ec9fa0e4139b724ef5/lib/json-schema/validator.rb#L40
        validator.instance_variable_set('@errors', [])
        # `JSON::Validator#initialize_data` does nothing, in our case.
        # `@@original_data` doesn't need to be re-initialized.
        # @see https://github.com/ruby-json-schema/json-schema/blob/fa316dc9d39b922935aed8ec9fa0e4139b724ef5/lib/json-schema/validator.rb#L53
        validator.instance_variable_set('@data', data)
        validator.validate
      end

    private

      # The json-schema gem is very, very slow, so we implement optimizations.

      # Memoizes and returns validators using a fragment of the schema.
      def validators
        @validators ||= Hash.new do |hash,name|
          v = validator.dup
          # @see https://github.com/ruby-json-schema/json-schema/blob/fa316dc9d39b922935aed8ec9fa0e4139b724ef5/lib/json-schema/validator.rb#L73
          v.instance_variable_set('@base_schema', v.schema_from_fragment(v.instance_variable_get('@base_schema'), "#/definitions/#{name}"))
          hash[name] = v
        end
      end

      # Memoizes a validator using the schema.
      def validator
        # `JSON::Validator#initialize_schema` runs faster if given a `Hash`.
        @@validator ||= JSON::Validator.new(JSON.load(File.read(File.expand_path(File.join('..', '..', '..', 'schemas', 'schema.json'), __FILE__))), {}, {
          # Keep the cache - whatever it is.
          clear_cache: false,
          # It's safe to skip data parsing if the data is a `Hash`.
          parse_data: false,
          # Push errors onto `@errors` instead of raising. Setting to false would
          # result in a single error being reported.
          record_errors: true,
          # `ValidationError#to_hash` is probably slower than
          # `ValidationError#to_string`, but it is not yet a bottleneck.
          errors_as_objects: true,
        })
      end
    end
  end
end
