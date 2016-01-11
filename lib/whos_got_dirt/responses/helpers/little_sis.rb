module WhosGotDirt
  module Responses
    module Helpers
      class LittleSisHelper < Response
        class << self
          # @!attribute [r] count_field
          #   @return [Hash] the field storing the number of results
          attr_reader :count_field

          # @private
          def date_formatter(property, path)
            return lambda{|data|
              [property, JsonPointer.new(data, path).value.sub(' ', 'T') + 'Z']
            }
          end

          # @private
          def integer_formatter(property, path)
            return lambda{|data|
              [property, Integer(JsonPointer.new(data, path).value)]
            }
          end
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

        # Returns the error message.
        def error_message
          parsed_body.strip
        end
      end
    end
  end
end
