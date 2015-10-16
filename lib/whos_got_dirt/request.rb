module WhosGotDirt
  # Accepts MQL parameters and return URLs to request.
  #
  # @example Create a new class for transforming parameters to URLs.
  #   class MyAPIRequest < WhosGotDirt::Request
  #     @base_url = 'https://api.example.com'
  #
  #     def to_s
  #       "#{base_url}/endpoint?#{to_query(input)}"
  #     end
  #   end
  #
  # @example Use the class in requesting a URL.
  #   url = MyAPIRequest.new(name: 'John Smith').to_s
  #   response = Faraday.get(url)
  #   #=> "https://api.example.com/endpoint?name=John+Smith"
  class Request
    class << self
      # @!attribute [r] base_url
      #   @return [String] the base URL to be used in the request
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

    # @!attribute input
    #   @return [Hash] the MQL parameters
    attr_accessor :input

    # @!attribute :output
    #   @return [Hash] the API-specific parameters
    attr_reader :output

    # Sets the MQL parameters.
    #
    # @param [Hash] input the MQL parameters
    def initialize(input = {})
      @input = ActiveSupport::HashWithIndifferentAccess.new(input)
      @output = {}
    end

    # Returns the base URL to be used in the request.
    #
    # @return [String] the base URL to be used in the request
    def base_url
      self.class.base_url
    end

    # Helper method to map a parameter that supports the MQL equality operator.
    #
    # @param [String] target the API-specific parameter name
    # @param [String] sources the request parameter name
    # @param [Hash] opts options
    # @option opts [String] :input substitute MQL parameters
    # @option opts [Set,Array] :valid a list of valid values
    # @return [Hash] the API-specific parameters
    def equal(target, source, opts = {})
      params = parameters(opts)

      if opts.key?(:valid)
        if opts[:valid].include?(params[source])
          output[target] = params[source]
        end
      else
        if params[source]
          output[target] = params[source]
        end
      end

      output
    end

    # Helper method to map a parameter that supports the MQL `~=` operator.
    #
    # @param [String] target the API-specific parameter name
    # @param [String] sources the request parameter name
    # @param [Hash] opts options
    # @option opts [String] :input substitute MQL parameters
    # @return [Hash] the API-specific parameters
    def match(target, source, opts = {})
      params = parameters(opts)

      if params[source]
        output[target] = params[source]
      elsif params["#{source}~="]
        output[target] = params["#{source}~="]
      end

      output
    end

    # Helper method to map a parameter that supports the MQL `|=` operator.
    #
    # @param [String] target the API-specific parameter name
    # @param [String] source the request parameter name
    # @param [Hash] opts options
    # @option opts [String] :input substitute MQL parameters
    # @return [Hash] the API-specific parameters
    def one_of(target, source, opts = {})
      params = parameters(opts)

      if Array === params[source]
        # @note OpenCorporates AND format.
        output[target] = params[source].join(',')
      elsif params[source]
        output[target] = params[source]
      elsif params["#{source}|="]
        # @note OpenCorporates OR format.
        output[target] = params["#{source}|="].join('|')
      end

      output
    end

    # Helper method to map a date parameter that supports comparisons.
    #
    # @param [String] target the API-specific parameter name
    # @param [String] source the request parameter name
    # @param [Hash] opts options
    # @option opts [String] :input substitute MQL parameters
    # @return [Hash] the API-specific parameters
    def date_range(target, source, opts = {})
      params = parameters(opts)

      # @note OpenCorporates date range format.
      if params[source]
        output[target] = "#{params[source]}:#{params[source]}"
      elsif params["#{source}>="] || params["#{source}>"] || params["#{source}<="] || params["#{source}<"]
        output[target] = "#{params["#{source}>="] || params["#{source}>"]}:#{params["#{source}<="] || params["#{source}<"]}"
      end

      output
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

    def parameters(opts)
      if opts.key?(:input)
        opts[:input]
      else
        input
      end
    end
  end
end
