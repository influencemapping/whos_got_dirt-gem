module WhosGotDirt
  module Responses
    module Helpers
      class OpenCorporatesHelper < Response
        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          JSON.load(body)['results']
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          parsed_body['total_count']
        end

        # Returns the current page number.
        #
        # @return [Fixnum] the current page number
        def page
          parsed_body['page']
        end
      end
    end
  end
end
