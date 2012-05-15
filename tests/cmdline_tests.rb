require 'tests_helper'

module FMS::CmdLine::Output
  def self.flush
    [@@buffer_stdout, @@buffer_stderr]
  end

  def self.clear
    @@buffer_stderr = []
    @@buffer_stdout = []
  end
end

class CommandLineTests < BaseTestCase

  # TODO: test mocked outputs

  def teardown
    super
    FMS::CmdLine::Output.clear
  end

  def test_should_call_method_based_on_command
    run_command ['get_apps', '--host=fms.example.com']
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms")
  end

  def test_should_call_method_passing_command_parameters
    run_command ['get_apps', '--host=fms.example.com', '--force=true']
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms&force=true")
  end

  def test_should_require_host_parameter
    run_command ['get_apps']
    assert_not_requested(:get, /.*/)
    assert_command_stderr_contains("--host option is required")
  end

  def test_should_show_help_if_invalid_command
    stub_request_to_404 "http://fms.nonexistent.com:1111/admin/invalidCommand?apswd=fms&auser=fms"
    run_command ["invalid_command", "--host=fms.nonexistent.com"]
    assert_requested(:get, "http://fms.nonexistent.com:1111/admin/invalidCommand?apswd=fms&auser=fms")
    assert_command_stderr_contains('"invalidCommand" is not a valid API method')
  end

  def test_show_error_msg_if_no_command_nor_options_provided
    run_command []
    assert_invalid_command
  end

  def test_show_error_msg_if_options_informed_before_command
    run_command ["--options-first=foo", "get_apps"]
    assert_invalid_command
  end

  def test_options_should_use_equal_sign_to_define_its_value
    run_command ["get_apps", "--force", "true"]
    assert_invalid_command
  end

  def test_help_command_should_show_usage_format
    run_command ["help"]
    assert_help_message
  end

  def test_should_return_response_as_string
    url = "http://fms.example.com:1111/admin/getLiveStreams?appInst=live&apswd=fms&auser=fms"
    stub_request(:get, url).to_return(:body => GET_LIVE_STREAMS)

    run_command ["get_live_streams", "--host=fms.example.com", "--app_inst=live"]
    assert_requested(:get, url)
    assert_command_stdout_contains GET_LIVE_STREAMS.strip
  end


  def run_command(argv)
    FMS::CmdLine.parse(argv)
  end

  def stub_request_to_404(url)
    WebMock.reset!
    stub_request(:get, url).to_return(:status => 404)
  end

  def assert_command_stderr_contains(msg)
    cmd_stdout, cmd_stderr = FMS::CmdLine::Output.flush
    assert_includes(cmd_stderr, msg)
  end

  def assert_command_stdout_contains(msg)
    cmd_stdout, cmd_stderr = FMS::CmdLine::Output.flush
    assert_includes(cmd_stdout, msg)
  end

  def assert_invalid_command
    assert_not_requested(:get, /.*/)
    assert_command_stderr_contains("Invalid command format.")
    assert_help_message
  end

  def assert_help_message
    assert_not_requested(:get, /.*/)
    assert_command_stdout_contains("\nUsage:")
    assert_command_stdout_contains("\nExample:")
  end

end

GET_LIVE_STREAMS = %Q{
<?xml version="1.0" encoding="utf-8"?>
<result>
  <level>status</level>
  <code>NetConnection.Call.Success</code>
  <timestamp>Mon May 14 22:47:45 2012</timestamp>
  <name>_defaultRoot_:_defaultVHost_:::_0</name>
  <data>
    <_0>stream1</_0>
    <_1>stream1</_2>
  </data>
</result>
}
