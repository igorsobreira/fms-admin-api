require 'minitest/autorun'
require 'webmock'

require 'fmsadmin/cli'

class BaseTestCase < MiniTest::Unit::TestCase
  include WebMock::API

  def invoke_command(name, options)
    cli = FMSAdmin::CLI.new([], options)
    cli.invoke(name)
  end

end
