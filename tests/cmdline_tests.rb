require 'tests_helper'

class FMS::CmdLine
  attr_accessor :stderr

  def show_error(msg)
    @stderr = [] unless @stderr
    @stderr << msg
  end

end

class CommandLineTests < BaseTestCase

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

  def test_show_error_msg_if_malformed_options
    run_command ["get_apps", "--force", "true"]
    assert_invalid_command
  end

  def run_command(argv)
    @cmd = FMS::CmdLine.new(argv)
    @cmd.parse
  end

  def command_stderr
    @cmd.stderr
  end

  def stub_request_to_404(url)
    WebMock.reset!
    stub_request(:get, url).to_return(:status => 404)
  end

  def assert_command_stderr_contains(msg)
    assert_includes(command_stderr, msg)
  end

  def assert_invalid_command
    assert_not_requested(:get, /.*/)
    assert_command_stderr_contains("Invalid command format. See help.")
  end

end
