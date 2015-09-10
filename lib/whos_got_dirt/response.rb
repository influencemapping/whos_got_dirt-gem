module WhosGotDirt
  # Accepts a response and returns the results in a consistent format.
  #
  # @example Create a new class for transforming responses to results.
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
  #   url = MyAPIRequest.new(name: 'John Smith').to_s
  #   response = Faraday.get(url)
  #   MyAPIResponse.new(response).to_a
  #   # [{
  #   #   :request_url=>"https://api.example.com/endpoint?name=John+Smith",
  #   #   :name=>"John Smith"
  #   # }, {
  #   #   :request_url=>"https://api.example.com/endpoint?name=John+Smith",
  #   #   :name=>"John Aaron Smith"
  #   # }]
  class Response < SimpleDelegator
    class << self
      # @!attribute [r] template
      #   @return [Hash] the result template
      attr_reader :template
    end

    # Returns the result renderer.
    #
    # @return the result renderer
    def renderer
      @renderer ||= Renderer.new(self.class.template)
    end

    # Returns the parsed response body.
    #
    # @return the parsed response body
    def parsed_body
      @parsed_body ||= parse_body
    end

    # @abstract Subclass and override {#parse_body} to parse the response body
    def parse_body
      raise NotImplementedError
    end

    # @abstract Subclass and override {#to_a} to transform the parsed response
    #   body into results
    def to_a
      raise NotImplementedError
    end

    # @!method initialize(response)
    #   Sets the response's response.
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
