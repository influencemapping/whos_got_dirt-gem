module WhosGotDirt
  module Requests
    module Entity
      # Requests for entities from the LittleSis API.
      #
      # Tokens less than two characters long will be ignored by LittleSis' `q`
      # filter. The `q` parameter matches names and aliases. If `search_all` is
      # `1`, it also matches descriptions and summaries.
      #
      # @example Supply an API key.
      #   "little_sis_api_key": "..."
      #
      # @example Match descriptions and summaries on `name~=` queries.
      #   "search_all": 1
      class LittleSis < Request
        # The JSON response has less metadata, e.g. number of results.
        @base_url = 'https://api.littlesis.org/entities.xml'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Returns the "OR" operator's serialization.
        #
        # @return [String] the "OR" operator's serialization
        def or_operator
          ','
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://api.littlesis.org/documentation#entities
        # @see http://api.littlesis.org/entities/types.json
        def convert
          match('q', 'name')
          one_of('type_ids', 'classification')
          equal('num', 'limit') # default 20, maximum 1000?
          equal('page', 'page')

          # API-specific parameters.
          equal('_key', 'little_sis_api_key')
          equal('search_all', 'search_all', valid: [1])

          output
        end
      end
    end
  end
end
