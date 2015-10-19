module WhosGotDirt
  module Requests
    module Entity
      # Requests for entities from the OpenDuka API.
      #
      # @example Supply an API key.
      #   "open_duka_api_key": "..."
      class OpenDuka < Request
        @base_url = 'http://www.openduka.org/index.php/api/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://www.openduka.org/index.php/api/documentation
        def convert
          match('term', 'name')

          # API-specific parameters.
          equal('key', 'open_duka_api_key')

          output
        end
      end
    end
  end
end
