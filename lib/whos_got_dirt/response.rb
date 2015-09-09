module WhosGotDirt
  # Accepts a response and returns the results in a consistent format.
  #
  # @example Create a class.
  #   class MyAPIResponse < WhosGotDirt::Response
  #     def to_a
  #       JSON.load(body).map do |result|
  #         {
  #           request_url: env.url.to_s,
  #           name: result['Name'],
  #         }
  #       end
  #     end
  #   end
  #
  # @example Use the class to parse a response.
  #   MyAPIResponse.new(response).to_a
  #   # [{
  #   #   :request_url=>"https://api.example.com/endpoint?name=John+Smith",
  #   #   :name=>"John Smith"
  #   # }, {
  #   #   :request_url=>"https://api.example.com/endpoint?name=John+Smith",
  #   #   :name=>"John Aaron Smith"
  #   # }]
  class Response < SimpleDelegator
    # @abstract Subclass and override {#to_a} to return the results in the
    #   response body, or an empty array if an error occurred
    def to_a
      raise NotImplementedError
    end

    # @!method initialize(response)
    #   @param [Faraday::Response] response a response

    # @!method body
    #   Returns the response body.
    #   @return [String] the response body

    # @!method env
    #   Returns the response's internals.
    #   @return [#url,#request_headers] the response's internals

    # @!method headers
    #   Returns the response headers.
    #   @return [#[]] the response headers

    # @!method status
    #   Returns the HTTP status code.
    #   @return [Fixnum] the HTTP status code
  end
end
