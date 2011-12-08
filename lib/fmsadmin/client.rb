require 'net/http'

module FMSAdmin

  class Client
    
    def initialize(host, user, password)
      @host = host
      @params = {
        :auser => user,
        :apswd => password
      }
    end

    def list_apps(force = false, verbose = true)
      extra_params = {
        :force => "false",
        :verbose => "false",
      }
      if force
        extra_params[:verbose] = "true"
        extra_params[:force] = "true"
      end
      if verbose
        extra_params[:verbose] = "true"
      end
      do_get 'getApps', extra_params
    end

    def add_app(app)
      do_get 'addApp', {:app => app}
    end

    def remove_app(app)
      do_get 'removeApp', {:appName => app}
    end

    def reload_app(app)
      do_get 'reloadApp', {:appInst => app}
    end

    def get_app_stats(app)
      do_get 'getAppStats', {:app => app}
    end

    def unload_app(app)
      do_get 'unloadApp', {:appInst => app}
    end

    def live_streams(app)
      do_get 'getLiveStreams', {:appInst => app}
    end

    private

    def do_get(action, options)
      Net::HTTP.get(build_url(action, options))
    end

    def build_url(method, extra_params = {})
      url = URI("http://#{@host}/admin/#{method}")
      url.query = URI.encode_www_form(@params.merge(extra_params))
      url
    end

  end

end
