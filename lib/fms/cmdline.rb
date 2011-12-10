
module FMS
  class CmdLine

    @@command_regex = /^[a-z_]+$/
    
    def initialize(argv)
      @argv = argv
    end

    def parse
      command = parse_command @argv.shift
      if !command
        show_error 'Invalid command format. See help.'
        return
      end
      params = parse_params(@argv)
      fire_method(command, params)
    end

    def parse_command(cmd)
      cmd if @@command_regex.match(cmd)
    end
    
    def parse_params(args)
      params = {}
      args.each do |arg|
        param, value = parse_param(arg)
        params[param.to_sym] = value
      end
      params
    end

    def parse_param(arg)
      m = /--(.*)=(.*)/.match(arg)
      m.captures if m
    end

    def fire_method(command, params)
      init_params, meth_params = split_params(params)
      begin
        client = FMS::Client.new(init_params)
        show_output client.send(command, meth_params)
      rescue ArgumentError => error
        show_error(error.message.gsub(':', '--'))
      rescue NoMethodError => error
        show_error(error.message)
      end
    end

    def split_params(params)
      init_params = {}
      meth_params = {}
      init_params_names = [:host, :port, :auser, :apswd]
      params.each_pair do |param, value|
        if init_params_names.include? param
          init_params[param] = value
        else
          meth_params[param] = value
        end
      end
      [init_params, meth_params]
    end

    def show_output(msg)
      puts msg
    end

    def show_error(msg)
      puts msg
      show_help
    end

    def show_help
      # TODO
    end

  end
end
