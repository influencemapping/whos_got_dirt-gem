module WhosGotDirt
  module Requests
    module Relation
      # Requests for corporate officerships from the OpenCorporates API.
      #
      # OpenCorporates' `date_of_birth` and `address` filters require an API
      # key. Its `order` parameter is not supported.
      #
      # @example Supply an API key.
      #   "open_corporates_api_key": "..."
      #
      # @example Find officerships by jurisdiction code.
      #   "jurisdiction_code": "gb"
      #
      # @example Find officerships with one of many jurisdiction codes.
      #   "jurisdiction_code|=": ["gb", "ie"]
      #
      # @example Find officerships by role.
      #   "role": "ceo"
      #
      # @example Find active officerships.
      #   "inactive": false
      #
      # @example Find inactive officerships.
      #   "inactive": true
      class OpenCorporates < Request
        @base_url = 'https://api.opencorporates.com/officers/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
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
          equal('per_page', 'limit', default: input['open_corporates_api_key'] && 100)

          input['subject'] && input['subject'].each do |subject|
            match('q', 'name', input: subject)
            date_range('date_of_birth', 'birth_date', input: subject)

            subject['contact_details'] && subject['contact_details'].each do |contact_detail|
              if contact_detail['type'] == 'address' && (contact_detail['value'] || contact_detail['value~='])
                output['address'] = contact_detail['value'] || contact_detail['value~=']
              end
            end
          end

          # API-specific parameters.
          equal('api_token', 'open_corporates_api_key')
          one_of('jurisdiction_code', 'jurisdiction_code', transform: lambda{|v| v.downcase})
          equal('position', 'role')
          equal('inactive', 'inactive', valid: [true, false])

          output
        end
      end
    end
  end
end
