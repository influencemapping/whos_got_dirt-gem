module WhosGotDirt
  # Accepts a response body and returns the results in a consistent format.
  #
  # @example Create a class.
  #   class MyAPIResponse < WhosGotDirt::Response
  #     @todo
  #   end
  #
  # @example Use the class to parse a response.
  #   MyAPIResponse.new(body) @todo
  class Response
    attr_reader :body

    # Sets the response's body.
    #
    # @param [String] body the response's body
    def initialize(body)
      @body = body
    end
  end
end
