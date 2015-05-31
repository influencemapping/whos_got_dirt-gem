module WhosGotDirt
  module Responses
    module People
      class OpenCorporates < Response
        # Parses a response into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          # @see http://api.opencorporates.com/documentation/REST-API-introduction
          if status == 200
            JSON.load(body)['results'].map do |result|
              # @todo respect `null` in MQL
            end
          else
            []
          end
        end
      end
    end
  end
end
