module WhosGotDirt
  module Responses
    module Entity
      # Converts entities from the OpenDuka API to Popolo format.
      #
      # @see http://www.openduka.org/index.php/api/documentation
      class OpenDuka < Response
        @template = {
          '@type' => 'Entity',
          'name' => '/Name',
          'identifiers' => [{
            'identifier' => '/ID',
            'scheme' => 'OpenDuka',
          }],
        }

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          JSON.load(body)
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
