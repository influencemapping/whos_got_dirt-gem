module WhosGotDirt
  module Requests
    module List
      # Requests for corporate groupings from the OpenCorporates API.
      #
      # OpenCorporates' `q` filter performs a prefix search.
      #
      # @example Supply an API key.
      #   "open_corporates_api_key": "..."
      class OpenCorporates < Request
        @base_url = 'https://api.opencorporates.com/corporate_groupings/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see https://api.opencorporates.com/documentation/API-Reference
        def convert
          match('q', 'name')
          equal('per_page', 'limit', default: input['open_corporates_api_key'] && 100)

          # API-specific parameters.
          equal('api_token', 'open_corporates_api_key')

          output
        end
      end
    end
  end
end
