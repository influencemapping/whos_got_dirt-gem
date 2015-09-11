module WhosGotDirt
  module Responses
    module Person
      # Converts corporate officers from the OpenCorporates API to Popolo format.
      #
      # @see http://api.opencorporates.com/documentation/REST-API-introduction
      class OpenCorporates < Response
        @template = {
          '@type' => 'Person',
          'name' => '/name',
          'birth_date' => '/date_of_birth',
          'updated_at' => '/retrieved_at',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'OpenCorporates',
          }, {
            'identifier' => '/uid',
            'scheme' => 'Company Register',
          }],
          'contact_details' => [{
            'type' => 'address',
            'value' => '/address',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates URL',
          }],
          'memberships' => [{
            'role' => '/position',
            'start_date' => '/start_date',
            'end_date' => '/end_date',
            'organization' => {
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
            # API-specific.
            'inactive' => '/inactive',
          }],
          # API-specific.
          'current_status' => '/current_status',
          'jurisdiction_code' => '/jurisdiction_code',
          'nationality' => '/nationality',
          'occupation' => '/occupation',
        }

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          JSON.load(body)['results']
        end

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['officers'].map do |data|
            Result.new('Person', renderer.result(data['officer']), self).finalize!
          end
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          parsed_body['total_count']
        end

        # Returns the current page number.
        #
        # @return [Fixnum] the current page number
        def page
          parsed_body['page']
        end
      end
    end
  end
end
