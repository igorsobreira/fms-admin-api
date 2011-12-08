require 'tests_helper'

class CommandsTests < BaseTestCase

  def setup
    stub_request(:get, /.*/)
  end

  def teardown
    WebMock.reset!
  end

  def test_list_apps_command_should_build_correct_url
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret"]
    invoke_command(:list_apps, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")
  end

  def test_list_apps_command_should_build_correct_url_using_force_and_verbose_is_implicit
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret",
               "--force"]    
    invoke_command(:list_apps, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=true&verbose=true")    
  end

  def test_list_apps_command_should_build_correct_url_using_verbose
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--verbose"]
    invoke_command(:list_apps, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")
  end

  def test_add_app_command_should_build_correct_url
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--app=live"]
    invoke_command(:add_app, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/addApp?apswd=secret&auser=fms&app=live")
  end

  def test_remove_app_command_should_build_correct_url
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--app=live"]
    invoke_command(:remove_app, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/removeApp?apswd=secret&auser=fms&appName=live")
  end

  def test_reload_app_command_should_build_correct_url
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--app=live"]
    invoke_command(:reload_app, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/reloadApp?apswd=secret&auser=fms&appInst=live")
  end

  def test_app_stats_command_should_build_the_correct_url
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret",
               "--app=live"]
    invoke_command(:app_stats, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getAppStats?apswd=secret&auser=fms&app=live")
  end

  def test_unload_app_command_should_build_correct_url
    options =   ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret",
                 "--app=live"]
    invoke_command(:unload_app, options)
    assert_requested(:get, "http://fms.example.com:1111/admin/unloadApp?apswd=secret&auser=fms&appInst=live")
  end

end
