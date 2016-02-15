module WhosGotDirt
  module Responses
    module Relation
      # Converts corporate officerships from the OpenCorporates API to Popolo format.
      #
      # @see https://api.opencorporates.com/documentation/API-Reference
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'Relation',
          'subject' => [{
            'name' => '/name',
            'birth_date' => '/date_of_birth',
            'contact_details' => [{
              'type' => 'address',
              'value' => '/address',
            }],
            # API-specific.
            'nationality' => '/nationality',
            'occupation' => '/occupation',
          }],
          'object' => {
            'name' => '/company/name',
            'identifiers' => [{
              'identifier' => '/company/company_number',
              'scheme' => 'Company Register',
            }],
            'links' => [{
              'url' => '/company/opencorporates_url',
              'note' => 'OpenCorporates page',
            }],
            # API-specific.
            'jurisdiction_code' => '/company/jurisdiction_code',
          },
          'start_date' => '/start_date',
          'end_date' => '/end_date',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'OpenCorporates',
          }, {
            'identifier' => '/uid',
            'scheme' => 'Company Register',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates page',
          }],
          'updated_at' => '/retrieved_at',
          # API-specific.
          'inactive' => '/inactive',
          'current_status' => '/current_status',
          'jurisdiction_code' => '/jurisdiction_code',
          'role' => '/position',
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['officers'].map do |data|
            Result.new('Relation', renderer.result(data['officer']), self).finalize!
          end
        end

        # Returns a relation's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the relation's URL
        def entity_url(result)
          query = CGI.parse(env.url.query.to_s)
          url = "#{env.url.scheme}://#{env.url.host}/officers/#{result['identifiers'][0]['identifier']}"
          if query['api_token']
            url += "?api_token=#{CGI.escape(query['api_token'][0].to_s)}"
          end
          url
        end
      end
    end
  end
end
