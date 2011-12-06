

module FMSAdmin
  module Command

    class Base < Thor

      def self.auth_options
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
