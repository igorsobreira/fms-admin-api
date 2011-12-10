
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
        if method and params
          call_method method, params
        else
          Output.stderr 'Invalid command format. See help.'
        end
      end

      def call_method(method, params)
        MethodCaller.call method, params
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
            Output.stdout c.send(method.to_sym, params)
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
          [:host, :port, :auser, :apswd].include? param
        end

      end
    end

    module Output
      class << self
        
        @@buffer_stdout = []
        @@buffer_stderr = []

        def stdout(out)
          @@buffer_stdout << out
        end

        def stderr(err)
          @@buffer_stderr << err
        end

        def flush
          puts @@buffer_stdout
          puts @@buffer_stderr
        end

      end
    end

  end
end
