module WhosGotDirt
  module Requests
    module List
      # Requests for lists from the LittleSis API.
      #
      # The `q` parameter matches names and descriptions.
      #
      # @example Supply an API key.
      #   "little_sis_api_key": "..."
      class LittleSis < Request
        # The JSON response has less metadata, e.g. number of results.
        @base_url = 'https://api.littlesis.org/lists.xml'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://api.littlesis.org/documentation#lists
        def convert
          match('q', 'name')
          equal('num', 'limit')

          # API-specific parameters.
          equal('_key', 'little_sis_api_key')

          output
        end
      end
    end
  end
end
