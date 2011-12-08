module FMS
  class ApiMethod
    
    attr_accessor :name, :desc
    
    def initialize
      yield self
    end
    
    def on_call(&block)
      add_http_client_method(block)
    end
    
    def add_http_client_method(block)
      Client.add_api_method(@name, block)
    end

  end
end
