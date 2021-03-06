module WhosGotDirt
  module Requests
    module Entity
      # Requests for companies from the OpenCorporates API.
      #
      # OpenCorporates' `fields` and `order` parameters are not supported.
      #
      # @example Supply an API key.
      #   "open_corporates_api_key": "..."
      #
      # @example Find companies by name prefix.
      #   "name~=" "ACME*"
      #
      # @example Find companies by jurisdiction code.
      #   "jurisdiction_code": "gb"
      #
      # @example Find companies with one of many jurisdiction codes.
      #   "jurisdiction_code|=": ["gb", "ie"]
      #
      # @example Find companies by country code.
      #   "country_code": "gb"
      #
      # @example Find companies with one of many country codes.
      #   "country_code|=": ["gb", "ie"]
      #
      # @example Find companies by status.
      #   "current_status": "Dissolved"
      #
      # @example Find companies by industry code.
      #   "industry_code": "be_nace_2008-66191"
      #
      # @example Find companies with all the given country codes.
      #   "a:industry_code": "be_nace_2008-66191",
      #   "b:industry_code": "be_nace_2008-66199"
      #
      # @example Find companies with one of many country codes.
      #   "industry_code|=": ["be_nace_2008-66191", "be_nace_2008-66199"]
      #
      # @example Find active companies (`true` for inactive).
      #   "inactive": false
      #
      # @example Find branch companies (`false` for non-branch).
      #   "branch": true
      #
      # @example Find nonprofit companies (`false` for others).
      #   "nonprofit": true
      class OpenCorporates < Request
        @base_url = 'https://api.opencorporates.com/companies/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
        end

        # Returns the "AND" operator's serialization.
        #
        # @return [String] the "AND" operator's serialization
        def and_operator
          ','
        end

        # Returns the "OR" operator's serialization.
        #
        # @return [String] the "OR" operator's serialization
        def or_operator
          '|'
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see https://api.opencorporates.com/documentation/API-Reference
        def convert
          match('q', 'name')
          equal('company_type', 'classification')
          equal('created_since', 'created_at>=')
          date_range('incorporation_date', 'founding_date')
          date_range('dissolution_date', 'dissolution_date')
          equal('per_page', 'limit', default: input['open_corporates_api_key'] && 100) # default 30
          equal('page', 'page')

          input['contact_details'] && input['contact_details'].each do |contact_detail|
            if contact_detail['type'] == 'address' && (contact_detail['value'] || contact_detail['value~='])
              output['registered_address'] = contact_detail['value'] || contact_detail['value~=']
            end
          end

          # API-specific parameters.
          equal('api_token', 'open_corporates_api_key')
          one_of('jurisdiction_code', 'jurisdiction_code', transform: lambda{|v| v.downcase})
          one_of('country_code', 'country_code', transform: lambda{|v| v.downcase})
          equal('current_status', 'current_status')
          all_of('industry_codes', 'industry_code', backup: :one_of)
          equal('inactive', 'inactive', valid: [true, false])
          equal('branch', 'branch', valid: [true, false])
          equal('nonprofit', 'nonprofit', valid: [true, false])

          output
        end
      end
    end
  end
end
