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
        client = FMSAdmin::Client.new(options.host, options.user, options.password)
        puts client.get_apps(options.force, options.verbose)
      end

      desc "add", "Adds a new application to the virtual host you are connected to by creating the required directory for the new application in the directory tree"
      basic_options
      app_name_option "The name of the application to be added."
      def add
        puts "add #{options.inspect}"
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
        puts "reload #{options.inspect}"
      end

      desc "unload", "Shuts down all instances of the specified application or instance of an application"
      basic_options
      app_name_option
      def unload
        puts "unload #{options.inspect}"
      end

    end

  end
end

