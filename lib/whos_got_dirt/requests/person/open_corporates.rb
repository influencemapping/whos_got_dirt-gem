module WhosGotDirt
  module Requests
    module Person
      # Requests for corporate officerships from the OpenCorporates API.
      #
      # The `date_of_birth` and `address` filters require an API key.
      #
      # @example Supply an OpenCorporates API key.
      #   "open_corporates_api_key": "..."
      #
      # @example Find active officerships.
      #   "memberships": [{
      #     "inactive": false
      #   }]
      #
      # @example Find inactive officerships.
      #   "memberships": [{
      #     "inactive": true
      #   }]
      #
      # @example Find people with a given jurisdiction code.
      #   "jurisdiction_code": "gb"
      #
      # @example Find people with one of many jurisdiction codes.
      #   "jurisdiction_code|=": ["gb", "ie"]
      class OpenCorporates < Request
        @base_url = 'https://api.opencorporates.com/officers/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://api.opencorporates.com/documentation/API-Reference
        def convert
          match('q', 'name')
          date_range('date_of_birth', 'birth_date')

          if input['memberships']
            input['memberships'].each do |membership|
              if membership['role']
                output['position'] = membership['role']
              end

              if [true, false].include?(membership['inactive'])
                output['inactive'] = membership['inactive']
              end
            end
          end

          if input['contact_details']
            input['contact_details'].each do |contact_detail|
              if contact_detail['type'] == 'address' && (contact_detail['value'] || contact_detail['value~='])
                output['address'] = contact_detail['value'] || contact_detail['value~=']
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
          equal('api_token', 'open_corporates_api_key')

          output
        end
      end
    end
  end
end
