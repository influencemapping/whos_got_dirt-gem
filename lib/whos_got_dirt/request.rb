module WhosGotDirt
  # Accepts parameters and return URLs to request.
  #
  # @example Create a class.
  #   class MyAPIRequest < WhosGotDirt::Request
  #     def to_s
  #       "https://api.example.com/endpoint?#{to_query(params)}"
  #     end
  #   end
  #
  # @example Use the class in requesting a URL.
  #   Faraday.get(MyAPIRequest.new(q: 'foo').to_s).body
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
    # @return the base URL to be used in the request
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
