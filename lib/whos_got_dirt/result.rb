module WhosGotDirt
  # A result from a response.
  class Result
    # @!attribute [r] result
    #   @return [Hash] the result
    attr_reader :result

    # @!attribute [r] response
    #   @return [Response] the response from which the result was created
    attr_reader :response

    # @!attribute [r] type
    #   @return [Response] the Popolo class to validate against
    attr_reader :type

    # Sets the result and response.
    #
    # @param [String] type the Popolo class to validate against
    # @param [Hash] result the rendered result
    # @param [Response] response the response from which the result was created
    def initialize(type, result, response)
      @type = type
      @result = result
      @response = response
    end

    # Adds an API URL for the result.
    #
    # @return [Hash] the result
    def add_link!
      if response.respond_to?(:entity_url)
        result['links'] ||= []
        result['links'] << {
          'url' => response.entity_url(result),
          'note' => response.class.name.rpartition('::')[2],
        }
      end
    end

    # Adds the requested URL as a source.
    #
    # @return [Hash] the result
    def add_source!
      result['sources'] ||= []
      result['sources'] << {
        'url' => response.env.url.to_s,
        'note' => response.class.name.rpartition('::')[2],
      }
      result
    end

    # Validates the result against its schema. If recognized errors occur, they
    # are corrected, and the result is revalidated; if any error occurs during
    # revalidation, an exception is raised.
    #
    # @param [Hash] opts options
    # @option opts [Boolean] :strict (false) whether to raise an error if any
    #   error occurs
    # @return [Hash] the result
    # @raise if an unrecognized error occurs, or if any error occurs during
    #   revalidation
    def validate!(opts = {})
      # The code assumes that processing errors in reverse avoids re-indexing
      # issues when deleting items from arrays. If this assumption is invalid,
      # we can delete items one at a time and re-validate using this skeleton:
      #
      # begin
      #   Validator.validate(result, type)
      # rescue JSON::Schema::ValidationError => e
      #   error = e.to_hash
      #   case error[:failed_attribute]
      #   when 'Properties'
      #     ...
      #     validate!
      #   ...
      #   end
      # end

      errors = Validator.validate(result, type)

      if opts[:strict] && errors.any?
        raise ValidationError.new(errors * '\n')
      end

      errors.reverse.each do |error|
        pointer = JsonPointer.new(result, error[:fragment][1..-1])

        case error.fetch(:failed_attribute)
        when 'Properties'
          # The property did not contain a required property. This should be due
          # to the source having a null value.
          pointer.delete
        when 'Type'
          # The property did not match one or more types. This should be due to
          # the source having an integer instead of string value.
          pointer.value = pointer.value.to_s
        else
          raise ValidationError.new("#{error.fetch(:message)} (#{pointer.value})")
        end
      end

      if errors.any?
        validate!(strict: true)
      end

      result
    end

    # Adds the requested URL as a source, validates the result against its
    # schema, and returns the updated result.
    #
    # @return [Hash] the result
    def finalize!
      add_link!
      add_source!
      validate!
      result
    end
  end
end
