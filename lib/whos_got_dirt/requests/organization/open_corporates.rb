module WhosGotDirt
  module Requests
    module Organization
      # Requests for companies from the OpenCorporates API.
      #
      # The `fields` parameter and sorting options are not supported.
      #
      # @example Supply an OpenCorporates API key.
      #   "open_corporates_api_key": "..."
      #
      # @example Find organizations by name prefix.
      #   "name~=" "ACME*"
      #
      # @example Find organizations with a given jurisdiction code.
      #   "jurisdiction_code": "gb"
      #
      # @example Find organizations with one of many jurisdiction codes.
      #   "jurisdiction_code|=": ["gb", "ie"]
      #
      # @example Find organizations with a given country code.
      #   "country_code": "gb"
      #
      # @example Find organizations with one of many country codes.
      #   "country_code|=": ["gb", "ie"]
      #
      # @example Find organizations with a given status.
      #   "current_status": "Dissolved"
      #
      # @example Find organizations with a given industry code.
      #   "industry_codes": "be_nace_2008-66191"
      #
      # @example Find organizations with all the given country codes.
      #   "industry_codes": ["be_nace_2008-66191", "be_nace_2008-66199"]
      #
      # @example Find organizations with one of many country codes.
      #   "industry_codes|=": ["be_nace_2008-66191", "be_nace_2008-66199"]
      #
      # @example Find active organizations (`true` for inactive).
      #   "inactive": false
      #
      # @example Find branch organizations (`false` for non-branch).
      #   "branch": true
      #
      # @example Find nonprofit organizations (`false` for others).
      #   "nonprofit": true
      class OpenCorporates < Request
        @base_url = 'https://api.opencorporates.com/companies/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
        end

        # Converts the MQL parameters to OpenCorporates API parameters.
        #
        # @return [Hash] OpenCorporates API parameters
        # @see http://api.opencorporates.com/documentation/API-Reference
        def convert
          match('q', 'name')
          equal('company_type', 'classification')
          equal('created_since', 'created_at>=')
          date_range('incorporation_date', 'founding_date>=')
          date_range('dissolution_date', 'dissolution_date>=')

          if input['contact_details']
            input['contact_details'].each do |contact_detail|
              if contact_detail['type'] == 'address' && contact_detail['value']
                output['registered_address'] = contact_detail['value']
              end
            end
          end

          if input['limit']
            output['per_page'] = input['limit']
          elsif input['open_corporates_api_key']
            output['per_page'] = 100
          end

          # API-specific parameters.

          one_of('jurisdiction_code', 'jurisdiction_code')
          one_of('country_code', 'country_code')
          equal('current_status', 'current_status')
          one_of('industry_codes', 'industry_codes')
          equal('inactive', 'inactive', valid: [true, false])
          equal('branch', 'branch', valid: [true, false])
          equal('nonprofit', 'nonprofit', valid: [true, false])
          equal('api_token', 'open_corporates_api_key')

          output
        end
      end
    end
  end
end
