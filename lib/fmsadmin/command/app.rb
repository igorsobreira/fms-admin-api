require 'fmsadmin/client.rb'

module FMSAdmin
  module Command
    class App < Base

      def self.app_name_option(desc = nil)
        desc ||= "The name of the application or instance of the application, in the form: application_name[/instance_name]"
        method_option :app, :aliases => "-a", :required => true, :desc => desc
      end

      desc "list", "Lists the names of all installed applications"
      basic_options
      method_option :force, :aliases => "-f", :type => :boolean, :default => false, :desc => "Forces a refresh of the cached list of applications"
      method_option :verbose, :aliases => "-v", :type => :boolean, :default => true, :desc => "true displays all the applications under a virtual host; false displays the total number of applications"
      def list
        puts fms_client.get_apps(options.force, options.verbose)
      end

      desc "add", "Adds a new application to the virtual host you are connected to by creating the required directory for the new application in the directory tree"
      basic_options
      app_name_option "The name of the application to be added."
      def add
        puts fms_client.add_app(options.app)
      end

      desc "remove", "remove application"
      basic_options
      app_name_option
      def remove
        puts "remove #{options.inspect}"
      end

      desc "reload",  "Shuts down an instance of the application, if running, and reloads it"
      basic_options
      app_name_option
      def reload
        puts fms_client.reload_app(options.app)
      end

      desc "unload", "Shuts down all instances of the specified application or instance of an application"
      basic_options
      app_name_option
      def unload
        puts fms_client.unload_app(options.app)
      end

      desc "stats", "Gets aggregate performance data for all instances of the specified application"
      basic_options
      app_name_option
      def stats
        puts fms_client.get_app_stats(options.app)
      end

      no_tasks do
        def fms_client
          FMSAdmin::Client.new(options.host, options.user, options.password)
        end
      end

    end
  end
end

