
module FMS
  module CmdLine
    
    def self.parse(args)
      command = args.shift
      params = build_params(args)
      fire_method(command, params)
    end
    
    def self.build_params(args)
      params = {}
      args.each do |arg|
        param, value = parse_param(arg)
        params[param.to_sym] = value
      end
      params
    end

    def self.parse_param(arg)
      m = /--(.*)=(.*)/.match(arg)
      m.captures if m
    end

    def self.fire_method(command, params)
      init_params, meth_params = split_params(params)
      client = FMS::Client.new(init_params)
      puts client.send(command, meth_params)
    end

    def self.split_params(params)
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

  end
end
