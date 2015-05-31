module WhosGotDirt
  # Accepts a response and returns the results in a consistent format.
  #
  # @example Create a class.
  #   class MyAPIResponse < WhosGotDirt::Response
  #     @todo
  #   end
  #
  # @example Use the class to parse a response.
  #   MyAPIResponse.new(response) @todo
  class Response < SimpleDelegator
    # Parses a response into results.
    #
    # @return [Array<Hash>] the results
    def to_a
      # @see http://api.opencorporates.com/documentation/REST-API-introduction
      if status == 200
        JSON.load(body)
      else
        nil
      end
    end
  end
end
