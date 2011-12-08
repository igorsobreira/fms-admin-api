require 'thor'
require 'thor/group'

require 'fmsadmin/client'

module FMSAdmin
  class CLI < Thor

    def self.basic_options
      method_option :host, :aliases => "-h", :required => true, :desc => "Host name of the FMS, in the form: fms.host.com[:port]"
      method_option :user, :aliases => "-u", :required => true
      method_option :password, :aliases => "-p", :required => true
    end

    def self.app_name_option(desc = nil)
      desc ||= "The name of the application or instance of the application, in the form: application_name[/instance_name]"
      method_option :app, :aliases => "-a", :required => true, :desc => desc
    end

    desc "list-apps", "Lists the names of all installed applications"
    basic_options
    method_option :force, :aliases => "-f", :type => :boolean, :default => false, :desc => "Forces a refresh of the cached list of applications"
    method_option :verbose, :aliases => "-v", :type => :boolean, :default => true, :desc => "true displays all the applications under a virtual host; false displays the total number of applications"
    def list_apps
      puts fms_client.get_apps(options.force, options.verbose)
    end

    desc "add-app", "Adds a new application to the virtual host you are connected to by creating the required directory for the new application in the directory tree"
    basic_options
    app_name_option "The name of the application to be added."
    def add_app
      puts fms_client.add_app(options.app)
    end

    desc "remove-app", "Removes the specified application or instance of an application from the virtual host"
    basic_options
    app_name_option
    def remove_app
      puts fms_client.remove_app(options.app)
    end

    desc "reload-app",  "Shuts down an instance of the application, if running, and reloads it"
    basic_options
    app_name_option
    def reload_app
      puts fms_client.reload_app(options.app)
    end

    desc "unload-app", "Shuts down all instances of the specified application or instance of an application"
    basic_options
    app_name_option
    def unload_app
      puts fms_client.unload_app(options.app)
    end

    desc "app-stats", "Gets aggregate performance data for all instances of the specified application"
    basic_options
    app_name_option
    def app_stats
      puts fms_client.get_app_stats(options.app)
    end

    desc "live-streams", "Show all live streams names being published to a specific instance"
    basic_options
    app_name_option "The name of the instance of an application, in the form: application_name[/instance_name]"
    def live_streams
      puts fms_client.live_streams(options.app)
    end

    no_tasks do
      def fms_client
        FMSAdmin::Client.new(options.host, options.user, options.password)
      end
    end

    private 

    def fms_client
      FMSAdmin::Client.new(options.host, options.user, options.password)
    end

  end
end
