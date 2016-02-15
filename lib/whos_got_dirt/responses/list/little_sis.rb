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
          'number_of_items' => integer_formatter('number_of_items', '/num_entities'),
          'item_list_order' => lambda{|data|
            v = JsonPointer.new(data, '/is_ranked').value
            if v == '1'
              v = 'ascending'
            else
              v = 'unordered'
            end
            ['item_list_order', v]
          },
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'LittleSis',
          }],
          'updated_at' => date_formatter('updated_at', '/updated_at'),
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          list = parsed_body['Data']['Lists']['List']
          if Hash === list
            list = [list]
          end
          list.map do |data|
            Result.new('List', renderer.result(data), self).finalize!
          end
        end

        # Returns a list's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the list's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          "#{env.url.scheme}://#{env.url.host}/list/#{result['identifiers'][0]['identifier']}.xml?_key=#{CGI.escape(query['_key'][0].to_s)}"
        end
      end
    end
  end
end
