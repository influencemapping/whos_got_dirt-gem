module WhosGotDirt
  module Responses
    module Relation
      # Converts corporate officerships from the OpenCorporates API to Popolo format.
      #
      # @see http://api.opencorporates.com/documentation/REST-API-introduction
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'Relation',
          'subject' => {
            'name' => '/name',
            'birth_date' => '/date_of_birth',
            'contact_details' => [{
              'type' => 'address',
              'value' => '/address',
            }],
            # API-specific.
            'nationality' => '/nationality',
            'occupation' => '/occupation',
          },
          'object' => {
            'name' => '/company/name',
            'identifiers' => [{
              'identifier' => '/company/company_number',
              'scheme' => 'Company Register',
            }],
            'links' => [{
              'url' => '/company/opencorporates_url',
              'note' => 'OpenCorporates URL',
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
            'note' => 'OpenCorporates URL',
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
            Result.new('Person', renderer.result(data['officer']), self).finalize!
          end
        end
      end
    end
  end
end
