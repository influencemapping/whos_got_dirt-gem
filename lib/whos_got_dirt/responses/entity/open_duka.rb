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

        # Returns an entity's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the entity's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          "#{env.url.scheme}://#{env.url.host}/index.php/api/entity?id=#{CGI.escape(result['identifiers'][0]['identifier'].to_s)}&key=#{CGI.escape(query['key'][0].to_s)}"
        end

        def success?
          super && Array === parsed_body
        end

        def error_message
          parsed_body['error']
        end
      end
    end
  end
end
