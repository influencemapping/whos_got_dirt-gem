module WhosGotDirt
  module Responses
    module Entity
      # Converts entities from the CorpWatch API to Popolo format.
      #
      # @see http://api.corpwatch.org/documentation/api_examples.html#A17
      class CorpWatch < Response
        @template = {
          '@type' => 'Entity',
          'name' => '/company_name',
          'identifiers' => [{
            'identifier' => '/cw_id',
            'scheme' => 'CorpWatch',
          }, {
            'identifier' => '/irs_number',
            'scheme' => 'IRS Employer Identification Number',
          }, {
            'identifier' => '/cik',
            'scheme' => 'SEC Central Index Key',
          }],
          'contact_details' => [{
            'type' => 'address',
            'value' => '/raw_address',
          }],
          # API-specific.
          'industry_code' => '/sic_code',
          'industry_name' => '/industry_name',
          'sector_code' => '/sic_sector',
          'sector_name' => '/sector_name',
          'country_code' => '/country_code',
          'subdiv_code' => '/subdiv_code',
          'min_year' => '/min_year',
          'max_year' => '/max_year',
          'source_type' => '/source_type',
          'num_parents' => '/num_parents',
          'num_children' => '/num_children',
          'top_parent_id' => '/top_parent_id',
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
          Integer(parsed_body['meta']['total_results'])
        end

        # Returns the current index.
        #
        # @return [Fixnum] the current index
        def index
          parsed_body['meta']['parameters']['index']
        end

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          if parsed_body['result']['companies']
            parsed_body['result']['companies'].map do |_,data|
              Result.new('Entity', renderer.result(data), self).finalize!
            end
          else
            []
          end
        end

        # Returns an entity's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the entity's URL
        def item_url(result)
          query = CGI.parse(env.url.query.to_s)
          url = "#{env.url.scheme}://#{env.url.host}#{env.url.path.sub(/\.json\z/, '')}/#{result['identifiers'][0]['identifier']}.json"
          if query['key'].any?
            url += "?key=#{CGI.escape(query['key'][0].to_s)}"
          end
          url
        end
      end
    end
  end
end
