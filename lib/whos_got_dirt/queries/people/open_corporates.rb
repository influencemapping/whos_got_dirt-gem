module WhosGotDirt
  module Queries
    module People
      # @example
      #   "jurisdiction_code": "gb"
      #
      # @example
      #   "jurisdiction_code|=": ["gb", "ie"]
      #
      # @see http://api.opencorporates.com/documentation/REST-API-introduction
      # @see http://api.opencorporates.com/documentation/API-Reference
      class OpenCorporates < Query
        @base_url = 'https://api.opencorporates.com/officers/search'

        class << self
          def convert(q, params)
            hash = {}

            hash['q'] = q

            if params['jurisdiction_code']
              hash['jurisdiction_code'] = params['jurisdiction_code']
            elsif params['jurisdiction_code|=']
              hash['jurisdiction_code'] = params['jurisdiction_code|='].join('|')
            end

            if params['birth_date']
              hash['date_of_birth'] = "#{params['birth_date']}:#{params['birth_date']}"
            elsif params['birth_date>='] || params['birth_date>'] || params['birth_date<='] || params['birth_date<']
              hash['date_of_birth'] = "#{params['birth_date>='] || params['birth_date>']}:#{params['birth_date<='] || params['birth_date<']}"
            end

            if params['memberships'] && params['memberships'][0]
              if params['memberships'][0]['role']
                hash['position'] = params['memberships'][0]['role']
              end

              if params['memberships'][0]['status'] == 'inactive'
                hash['inactive'] = 'true'
              elsif params['memberships'][0]['status'] == 'active'
                hash['inactive'] = 'false'
              end
            end

            if params['contact_details'] && params['contact_details'][0]
              if params['contact_details'][0]['type'] == 'address' && params['contact_details'][0]['value']
                hash['address'] = params['contact_details'][0]['value']
              end
            end

            if params['api_key']
              hash['api_token'] = params['api_key']
              hash['per_page'] = 100
            end

            hash
          end
        end

        def convert
          self.class.convert(q, params)
        end

        def to_s
          "#{base_url}?#{to_query(convert.merge(order: 'score'))}"
        end
      end
    end
  end
end
