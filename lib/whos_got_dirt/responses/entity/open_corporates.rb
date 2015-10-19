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
          'created_at' => '/created_at',
          'updated_at' => '/updated_at',
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
            'retrieved_at' => '/sources/retrieved_at', # @todo check Dublin Core, etc.
          }],
          # API-specific.
          'branch_status' => '/branch_status', # @todo if boolean, use "branch" as in request
          'current_status' => '/current_status',
          'inactive' => '/inactive',
          'jurisdiction_code' => '/jurisdiction_code',
          'retrieved_at' => '/retrieved_at', # @todo check Dublin Core, etc.
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['companies'].map do |data|
            Result.new('Organization', renderer.result(data['company']), self).finalize!
          end
        end
      end
    end
  end
end
