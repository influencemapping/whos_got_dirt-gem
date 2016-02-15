module WhosGotDirt
  module Responses
    module List
      # Converts corporate groupings from the OpenCorporates API to Popolo format.
      #
      # @see https://api.opencorporates.com/documentation/API-Reference
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'List',
          'name' => '/name',
          'identifiers' => [{
            'identifier' => '/wikipedia_id',
            'scheme' => 'Wikipedia',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates page',
          }],
          'created_at' => '/created_at',
          'updated_at' => '/updated_at',
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['corporate_groupings'].map do |data|
            Result.new('List', renderer.result(data['corporate_grouping']), self).finalize!
          end
        end

        # Returns a list's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the list's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          url = "#{env.url.scheme}://#{env.url.host}/corporate_groupings/#{CGI.escape(result['name'].to_s)}"
          if query['api_token'].any?
            url += "?api_token=#{CGI.escape(query['api_token'][0].to_s)}"
          end
          url
        end
      end
    end
  end
end
