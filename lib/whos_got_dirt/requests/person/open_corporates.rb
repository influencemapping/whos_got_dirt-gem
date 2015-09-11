module WhosGotDirt
  module Requests
    module Person
      # Requests for corporate officers from the OpenCorporates API.
      #
      # The `date_of_birth` and `address` filters require an API key.
      #
      # @example Supply an OpenCorporates API key.
      #   "open_corporates_api_key": "..."
      #
      # @example Find active officers.
      #   "memberships": [{
      #     "inactive": false
      #   }]
      #
      # @example Find inactive officers.
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

        # Converts the MQL parameters to OpenCorporates API parameters.
        #
        # @return [Hash] OpenCorporates API parameters
        # @see http://api.opencorporates.com/documentation/API-Reference
        def convert
          equal('q', 'name', 'name~=')

          if input['birth_date']
            output['date_of_birth'] = "#{input['birth_date']}:#{input['birth_date']}"
          elsif input['birth_date>='] || input['birth_date>'] || input['birth_date<='] || input['birth_date<']
            output['date_of_birth'] = "#{input['birth_date>='] || input['birth_date>']}:#{input['birth_date<='] || input['birth_date<']}"
          end

          if input['memberships']
            input['memberships'].each do |membership|
              if membership['role']
                output['position'] = membership['role']
              end

              if membership['inactive'] == true
                output['inactive'] = 'true'
              elsif membership['inactive'] == false
                output['inactive'] = 'false'
              end
            end
          end

          if input['contact_details']
            input['contact_details'].each do |contact_detail|
              if contact_detail['type'] == 'address' && contact_detail['value']
                output['address'] = contact_detail['value']
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

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
        end
      end
    end
  end
end
