module WhosGotDirt
  module Requests
    module Entity
      # Requests for entities from the Poderopedia API.
      #
      # The Poderopedia API returns 10 results only, without pagination.
      #
      # The `entity` filter is required.
      #
      # @example Supply an API key.
      #   "poderopedia_api_key": "..."
      #
      # @example Find entities of the class `Person` or `Organization`.
      #   "entity": "Person"
      class Poderopedia < Request
        @base_url = 'http://api.poderopedia.org/visualizacion/search'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          "#{base_url}?#{to_query(convert)}"
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://api.poderopedia.org/search
        def convert
          match('alias', 'name')

          # API-specific parameters.
          equal('user_key', 'poderopedia_api_key')
          match('entity', 'type', valid: ['Person', 'Organization'], transform: lambda{|v|
            case v
            when 'persona'
              'Person'
            when 'organizacion'
              'Organization'
            end
          })

          output
        end
      end
    end
  end
end
