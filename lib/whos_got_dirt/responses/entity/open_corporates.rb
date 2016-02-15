module WhosGotDirt
  module Responses
    module Entity
      # Converts companies from the OpenCorporates API to Popolo format.
      #
      # @see https://api.opencorporates.com/documentation/API-Reference
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'Entity',
          'name' => '/name',
          'classification' => '/company_type',
          'founding_date' => '/incorporation_date',
          'dissolution_date' => '/dissolution_date',
          'other_names' => [{
            'name' => '/previous_names/company_name',
            'start_date' => '/previous_names/start_date',
            'end_date' => '/previous_names/end_date',
            'note' => '/previous_names/type',
          }],
          'identifiers' => [{
            'identifier' => '/company_number',
            'scheme' => 'Company Register',
          }],
          'contact_details' => [{
            'type' => 'address',
            'value' => '/registered_address_in_full',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates page',
          }, {
            'url' => '/registry_url',
            'note' => 'Register page',
          }],
          'sources' => [{
            'url' => '/sources/url',
            'note' => '/sources/publisher',
            # API-specific.
            'retrieved_at' => '/sources/retrieved_at',
          }],
          'created_at' => '/created_at',
          'updated_at' => '/updated_at',
          # API-specific.
          'branch_status' => '/branch_status',
          'current_status' => '/current_status',
          'inactive' => '/inactive',
          'jurisdiction_code' => '/jurisdiction_code',
          'retrieved_at' => '/retrieved_at',
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['companies'].map do |data|
            Result.new('Entity', renderer.result(data['company']), self).finalize!
          end
        end

        # Returns an entity's URL.
        #
        # @param [Hash] result the rendered result
        # @return [String] the entity's URL
        def entity_url(result)
          query = CGI.parse(env.url.query.to_s)
          url = "#{env.url.scheme}://#{env.url.host}/companies/#{result['jurisdiction_code']}/#{result['identifiers'][0]['identifier']}"
          if query['api_token']
            url += "?api_token=#{CGI.escape(query['api_token'][0].to_s)}"
          end
          url
        end
      end
    end
  end
end
