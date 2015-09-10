module WhosGotDirt
  module Requests
    module Person
      # Requests for corporate officers from the OpenCorporates API.
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

        class << self
          # Converts the request's parameters to OpenCorporates API parameters.
          #
          # @param [Hash] params the request's parameters
          # @return [Hash] OpenCorporates API parameters
          # @see http://api.opencorporates.com/documentation/API-Reference
          def convert(params)
            hash = {}

            if params['name'] || params['name~=']
              hash['q'] = params['name'] || params['name~=']
            end

            if params['birth_date']
              hash['date_of_birth'] = "#{params['birth_date']}:#{params['birth_date']}"
            elsif params['birth_date>='] || params['birth_date>'] || params['birth_date<='] || params['birth_date<']
              hash['date_of_birth'] = "#{params['birth_date>='] || params['birth_date>']}:#{params['birth_date<='] || params['birth_date<']}"
            end

            if params['memberships']
              params['memberships'].each do |membership|
                if membership['role']
                  hash['position'] = membership['role']
                end

                if membership['inactive'] == true
                  hash['inactive'] = 'true'
                elsif membership['inactive'] == false
                  hash['inactive'] = 'false'
                end
              end
            end

            if params['contact_details']
              params['contact_details'].each do |contact_detail|
                if contact_detail['type'] == 'address' && contact_detail['value']
                  hash['address'] = contact_detail['value']
                end
              end
            end

            if params['limit']
              hash['per_page'] = params['limit']
            elsif params['open_corporates_api_key']
              hash['per_page'] = 100
            end

            # API-specific parameters.

            if params['jurisdiction_code']
              hash['jurisdiction_code'] = params['jurisdiction_code']
            elsif params['jurisdiction_code|=']
              hash['jurisdiction_code'] = params['jurisdiction_code|='].join('|')
            end

            if params['open_corporates_api_key']
              hash['api_token'] = params['open_corporates_api_key']
            end

            hash
          end
        end

        # Converts the request's parameters to OpenCorporates API parameters.
        #
        # @return [Hash] OpenCorporates API parameters
        def convert
          self.class.convert(params)
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
