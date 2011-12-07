$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'webmock/rspec'
require 'cli'

def invoke_command(command, subcommand, options)
  args = [subcommand]
  commands = {
    :app => FMSAdmin::Command::App,
  }
  cli = FMSAdmin::CLI.new(args, options)
  cli.invoke(commands[command.to_sym], args)
end
