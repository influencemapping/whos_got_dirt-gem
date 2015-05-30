module WhosGotDirt
  class Query
    class << self
      attr_reader :base_url

      def to_query(params)
        params.map do |key,value|
          "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end * '&'
      end
    end

    attr_accessor :params

    def initialize(params = {})
      @params = ActiveSupport::HashWithIndifferentAccess.new(params)
    end

    def base_url
      self.class.base_url
    end

    def to_s
      raise NotImplementedError
    end

  private

    def to_query(params)
      self.class.to_query(params)
    end
  end
end
