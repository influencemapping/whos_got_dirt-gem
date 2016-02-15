module WhosGotDirt
  module Responses
    module Entity
      # Converts entities from the LittleSis API to Popolo format.
      #
      # @see http://api.littlesis.org/documentation
      class LittleSis < Helpers::LittleSisHelper
        @count_field = 'Entities'

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
            'note' => 'LittleSis page',
          }, {
            'url' => '/api_uri',
            'note' => 'LittleSis API detail',
          }],
          'updated_at' => date_formatter('updated_at', '/updated_at'),

          # Class-specific.
          'start_date' => lambda{|data|
            if JsonPointer.new(data, '/primary_type').value == 'Person'
              k = 'birth_date'
            else # 'Org'
              k = 'founding_date'
            end
            [k, JsonPointer.new(data, '/start_date').value]
          },
          'end_date' => lambda{|data|
            if JsonPointer.new(data, '/primary_type').value == 'Person'
              k = 'death_date'
            else # 'Org'
              k = 'dissolution_date'
            end
            [k, JsonPointer.new(data, '/end_date').value]
          },
          'parent_id' => '/parent_id',

          # API-specific.
          'is_current' => '/is_current',
          'summary' => '/summary',
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          list = parsed_body['Data']['Entities']['Entity']
          if Hash === list
            list = [list]
          end
          list.map do |data|
            Result.new('Entity', renderer.result(data), self).finalize!
          end
        end

        # Returns an entity's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the entity's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          "#{env.url.scheme}://#{env.url.host}/entity/#{result['identifiers'][0]['identifier']}.xml?_key=#{CGI.escape(query['_key'][0].to_s)}"
        end
      end
    end
  end
end
