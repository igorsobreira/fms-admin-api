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


  def run_command(argv)
    @cmd = FMS::CmdLine.new(argv)
    @cmd.parse
  end

  def command_stderr
    @cmd.stderr
  end

  def assert_command_stderr_contains(msg)
    assert_includes(command_stderr, msg)
  end

end
