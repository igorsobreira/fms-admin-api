require 'colorize'

module FMS

  module CmdLine
    class << self
      
      def parse(argv)
        method = MethodParser.parse(argv)
        params = ParamsParser.parse(argv)
        call_if_possible method, params
        Output.flush
      end

      def call_if_possible(method, params)
        return Output.help_message if help_method? method

        if method and params
          call_method method, params
        else
          Output.invalid_command
          Output.help_message
        end
      end

      def call_method(method, params)
        MethodCaller.call method, params
      end

      def help_method?(method)
        method == "help"
      end

    end

    module MethodParser
      class << self
 
        def parse(argv)
          method = argv.shift
          return nil unless method
          return nil unless /^[a-z_]+$/.match(method)
          method
        end

      end
    end

    module ParamsParser
      class << self
        
        def parse(argv)
          params = {}
          argv.each do |rawparam|
            param = parse_rawparam rawparam
            params.update(param) if param
          end
          return nil if params.length != argv.length
          params
        end

        def parse_rawparam(raw)
          m = /--(.*)=(.*)/.match(raw)
          {m[1].to_sym => m[2]} if m
        end

      end
    end

    module MethodCaller
      class << self

        def call(method, params)
          init_params = filter_init_params params
          begin
            c = FMS::Client.new(init_params)
            Output.stdout c.send(method.to_sym, params).to_s
          rescue ArgumentError => error
            Output.stderr error.message.gsub(':','--')
          rescue NoMethodError => error
            Output.stderr error.message
          end
        end

        def filter_init_params(params)
          init_params = {}
          params.each_pair do |key,value| 
            if init_param? key
              init_params[key] = value
              params.delete key
            end
          end
          init_params
        end
        
        def init_param?(param)
          [:host, :port, :auser, :apswd, :timeout].include? param
        end

      end
    end

    module Output
      class << self
        
        @@buffer_stdout = []
        @@buffer_stderr = []

        def invalid_command
          stderr "Invalid command format."
        end

        def help_message
          stdout "\nCommand line interface to Flash Media Server Administration API"
          stdout "\nUsage:"
          stdout "\n $ fmsapi <method_name> --host=<fms host> [other params]"
          stdout "\nJust pick a method from the documentation and replace convention "
          stdout "from camelCase to underscore_case (same for the parameters)"
          stdout "\nExample:"
          stdout "\n $ fmsapi reload_app --host=fms.example.com --auser=fms --apswd=secret --app_inst=live"
          stdout "\nFMS Admin API documentation: #{FMS::Docs}"
          stdout "This project documentation: http://github.com/igorsobreira/fms-admin-api"
        end

        def stdout(out)
          @@buffer_stdout << out
        end

        def stderr(err)
          @@buffer_stderr << err
        end

        def flush
          puts @@buffer_stderr.join("\n").red
          puts @@buffer_stdout.join("\n")
        end

      end
    end

  end
end
