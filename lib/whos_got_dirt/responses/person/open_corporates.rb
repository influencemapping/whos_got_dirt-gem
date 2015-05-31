module WhosGotDirt
  module Responses
    module Person
      class OpenCorporates < Response
        MAP = {
          # @todo
        }

        # Parses a response into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          # @see http://api.opencorporates.com/documentation/REST-API-introduction
          if status == 200
            # @todo respect `null` in MQL
            JSON.load(body)['results'].map do |result|
              hash = {}
              result.each do |key,value|
                hash[MAP.fetch(key, key)] = value
              end
              hash
            end
          else
            []
          end
        end
      end
    end
  end
end
