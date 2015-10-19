module WhosGotDirt
  module Responses
    module Entity
      # Converts entities from the Poderopedia API to Popolo format.
      #
      # @see http://api.poderopedia.org/search
      class Poderopedia < Response
        @template = {
          '@type' => 'Entity',
          'name' => '/alias',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'Poderopedia',
          }],
          'description' => '/shortBio'
        }

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          parsed = JSON.load(body)
          parsed['organization'] || parsed['person']
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          parsed_body.size
        end

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body.map do |data|
            Result.new('Entity', renderer.result(data), self).finalize!
          end
        end
      end
    end
  end
end
