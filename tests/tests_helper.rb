require 'minitest/autorun'
require 'webmock'

require 'fmsadmin/cli'

class BaseTestCase < MiniTest::Unit::TestCase
  include WebMock::API

  def invoke_command(command, subcommand, options)
    args = [subcommand]
    commands = {
      :app => FMSAdmin::Command::App,
    }
    cli = FMSAdmin::CLI.new(args, options)
    cli.invoke(commands[command.to_sym], args)
  end

end
