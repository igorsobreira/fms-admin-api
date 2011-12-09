require 'tests_helper'

class CommandLineTests < BaseTestCase

  def test_should_call_method_based_on_command
    FMS::CmdLine.parse(['get_apps', '--host=fms.example.com'])
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms")
  end

  def test_should_call_method_passing_command_parameters
    FMS::CmdLine.parse(['get_apps', '--host=fms.example.com', '--force=true'])
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms&force=true")
  end

end
