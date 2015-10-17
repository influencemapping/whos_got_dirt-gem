module WhosGotDirt
  module Responses
    module List
      # Converts lists from the OpenCorporates API to Popolo format.
      #
      # @see http://api.littlesis.org/documentation
      class LittleSis < Helpers::LittleSisHelper
        @count_field = 'Lists'

        @template = {
          '@type' => 'List',
          'name' => '/name',
          'description' => '/description',
          'number_of_items' => '/num_entities',
          'item_list_order' => lambda{|data|
            v = JsonPointer.new(data, '/is_ranked').value
            if v == '1'
              v = 'ascending'
            else
              v = 'unordered'
            end
            ['item_list_order', v]
          },
          'updated_at' => '/updated_at',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'LittleSis',
          }],
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['Data']['Lists']['List'].map do |data|
            Result.new('List', renderer.result(data), self).finalize!
          end
        end
      end
    end
  end
end
