require 'net/http'

module FMS
  class Client

    class << self
      def add_api_method(name, block)
        define_method(name, block)
      end

      def del_api_method(name)
        undef_method(name)
      end
    end

    attr_reader :host, :port, :user, :password

    def initialize(host, user, password, port = 1111)
      @host = host
      @port = port
      @params = {:auser => user, :apswd => password}
    end

    def do_get(action, options = {})
      Net::HTTP.get(build_url(action, options))
    end
    
    def build_url(method, extra_params = {})
      url = URI("http://#{@host}:#{@port}/admin/#{method}")
      url.query = URI.encode_www_form(@params.merge(extra_params))
      url
    end

  end
end
