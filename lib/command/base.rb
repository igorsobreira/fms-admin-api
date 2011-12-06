

module FMSAdmin
  module Command

    class Base < Thor

      def self.basic_options
        method_option :host, :aliases => "-h", :required => true, :desc => "Host name of the FMS, in the form: fms.host.com[:port]"
        method_option :user, :aliases => "-u", :required => true
        method_option :password, :aliases => "-p", :required => true
      end

      protected

      def self.basename
        super + ' app'
      end
      
    end

  end
end
