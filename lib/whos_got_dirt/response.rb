module WhosGotDirt
  # Accepts a response and returns the results in a consistent format.
  #
  # @example Create a class.
  #   class MyAPIResponse < WhosGotDirt::Response
  #     @todo
  #   end
  #
  # @example Use the class to parse a response.
  #   MyAPIResponse.new(response).to_a
  class Response < SimpleDelegator
    # @abstract Subclass and override {#to_a} to return the results in the
    #   response, or an empty array if an error occurred
    def to_a
      raise NotImplementedError
    end
  end
end
