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
          'description' => '/shortBio',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'Poderopedia',
          }],
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

        # Returns an entity's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the entity's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          "#{env.url.scheme}://#{env.url.host}/visualizacion/getEntityById?id=#{CGI.escape(result['identifiers'][0]['identifier'].to_s)}&entity=#{CGI.escape(query['entity'][0].to_s)}&user_key=#{CGI.escape(query['user_key'][0].to_s)}"
        end
      end
    end
  end
end
