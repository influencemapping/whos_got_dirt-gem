module WhosGotDirt
  module Responses
    module Entity
      # Converts entities from the LittleSis API to Popolo format.
      #
      # @see http://api.littlesis.org/documentation
      class LittleSis < Response
        @template = {
          '@type' => 'Entity',
          'type' => '/primary_type',
          'name' => '/name',
          'description' => '/description',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'LittleSis',
          }],
          'links' => [{
            'url' => '/website',
            'note' => 'Website',
          }, {
            'url' => '/uri',
            'note' => 'LittleSis URL',
          }, {
            'url' => '/api_uri',
            'note' => 'LittleSis API URL',
          }],
          'updated_at' => '/updated_at',

          # Class-specific.
          'start_date' => lambda{|data|
            v = JsonPointer.new(data, '/start_date').value
            if JsonPointer.new(data, '/primary_type').value == 'Person'
              ['birth_date', v]
            else # 'Org'
              ['founding_date', v]
            end
          },
          'end_date' => lambda{|data|
            v = JsonPointer.new(data, '/end_date').value
            if JsonPointer.new(data, '/primary_type').value == 'Person'
              ['death_date', v]
            else # 'Org'
              ['dissolution_date', v]
            end
          },
          'parent_id' => '/parent_id',

          # API-specific.
          'is_current' => '/is_current',
          'summary' => '/summary',
        }

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          Nori.new.parse(body)['Response']
        end

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['Data']['Entities']['Entity'].map do |data|
            Result.new('Entity', renderer.result(data), self).finalize!
          end
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          Integer(parsed_body['Meta']['TotalCount'])
        end

        # Returns the current page number.
        #
        # @return [Fixnum] the current page number
        def page
          Integer(parsed_body['Meta']['Parameters']['page'] || 1)
        end
      end
    end
  end
end
