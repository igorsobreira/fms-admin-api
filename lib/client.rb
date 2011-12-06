
require 'net/http'

module FMSAdmin

  class Client
    
    def initialize(host, user, password)
      @host = host
      @user = user
      @password = password
    end

    def url
      URI("http://#{@host}/admin/getApps?auser=#{@user}&apswd=#{@password}")
    end

    def get_apps(force = false)
      Net::HTTP.get(url)
    end

  end

end
