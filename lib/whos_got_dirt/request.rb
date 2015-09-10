module WhosGotDirt
  # Accepts parameters and return URLs to request.
  #
  # @example Create a new class for transforming parameters to URLs.
  #   class MyAPIRequest < WhosGotDirt::Request
  #     @base_url = 'https://api.example.com'
  #
  #     def to_s
  #       "#{base_url}/endpoint?#{to_query(params)}"
  #     end
  #   end
  #
  # @example Use the class in requesting a URL.
  #   url = MyAPIRequest.new(name: 'John Smith').to_s
  #   response = Faraday.get(url)
  #   #=> "https://api.example.com/endpoint?name=John+Smith"
  class Request
    class << self
      # @return [String] the base URL to be used in the request
      attr_reader :base_url

      # Transforms a query string from a hash to a string.
      #
      # @param [Hash] params query string parameters
      # @return [String] a query string
      def to_query(params)
        params.map do |key,value|
          "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end * '&'
      end
    end

    # @return [Hash] the request's parameters
    attr_accessor :params

    # Sets the request's parameters.
    #
    # @param [Hash] params the request's parameters
    def initialize(params = {})
      @params = ActiveSupport::HashWithIndifferentAccess.new(params)
    end

    # Returns the base URL to be used in the request.
    #
    # @return [String] the base URL to be used in the request
    def base_url
      self.class.base_url
    end

    # @abstract Subclass and override {#to_s} to return the URL from which to
    #   `GET` the results
    def to_s
      raise NotImplementedError
    end

  private

    def to_query(params)
      self.class.to_query(params)
    end
  end
end
