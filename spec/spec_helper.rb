$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'webmock/rspec'
require 'fmsadmin/cli'

def invoke_command(command, subcommand, options)
  args = [subcommand]
  commands = {
    :app => FMSAdmin::Command::App,
  }
  cli = FMSAdmin::CLI.new(args, options)
  cli.invoke(commands[command.to_sym], args)
end


#
# This matcher works by stubing the expected request url,
# and since WebMock raises and exception if any other url 
# is asked, I can tell if the test has built the wrong url
#
# The sad thing is that there is no way to get the requested
# url from WebMock API, so I parse the exception string...
#
# FIXME: should fail if any request is sent
#
RSpec::Matchers.define :build_url do |expected|
  match do |actual|
    matched = true
    stub_request(:get, expected)

    begin
      invoke_command(*actual)
    rescue WebMock::NetConnectNotAllowedError => error
      got_url = error.message.split(" ")[8]
      failure_message_for_should do |actual|
        "expected #{expected.inspect}\nbut got: #{got_url.inspect}"
      end
      matched = false
    end

    matched
  end
end
