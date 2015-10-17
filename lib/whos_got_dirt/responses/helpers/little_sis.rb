module WhosGotDirt
  module Responses
    module Helpers
      class LittleSisHelper < Response
        class << self
          # @!attribute [r] count_field
          #   @return [Hash] the field storing the number of results
          attr_reader :count_field
        end

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          Nori.new.parse(body)['Response']
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          Integer(parsed_body['Meta']['TotalCount'] || parsed_body['Meta']['ResultCount'][self.class.count_field])
        end

        # Returns the current page number.
        #
        # @return [Fixnum] the current page number
        def page
          Integer(parsed_body['Meta']['Parameters']['page'] || 1)
        end
      end
    end
  end
end
