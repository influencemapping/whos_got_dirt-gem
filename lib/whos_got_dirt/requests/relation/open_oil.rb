module WhosGotDirt
  module Requests
    module Relation
      # Requests for concessions from the OpenOil API.
      #
      # @example Supply an API key.
      #   "open_oil_api_key": "..."
      #
      # @example Find concessions with a given country code.
      #   "country_code": "br"
      #
      # @example Find concessions with a "licensed" or "unlicensed" status.
      #   "status": "licensed"
      #
      # @example Find concessions with an "offshore" or "onshore" type.
      #   "type": "offshore"
      class OpenOil < Request
        @base_url = 'https://api.openoil.net/concession/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://openoil.net/openoil-api/
        def convert
          equal('per_page', 'limit')

          input['subject'] && input['subject'].each do |subject|
            equal('licensee', 'name', input: subject)
          end

          # API-specific parameters.
          equal('apikey', 'open_oil_api_key')
          equal('country', 'country_code', transform: lambda{|v| v.upcase})
          equal('status', 'status', valid: ['licensed', 'unlicensed'])
          equal('type', 'type', valid: ['offshore', 'onshore'])

          output
        end
      end
    end
  end
end
