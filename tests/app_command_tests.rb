require 'tests_helper'

class AppCommandTests < BaseTestCase

  def setup
    stub_request(:get, /.*/)
  end

  def teardown
    WebMock.reset!
  end

  # app list

  def test_list_command_should_build_correct_url
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret"]
    invoke_command('app', 'list', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")    
  end

  def test_list_command_should_build_correct_url_using_force_and_verbose_is_implicit
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret",
               "--force"]    
    invoke_command('app', 'list', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=true&verbose=true")    
  end

  def test_list_command_should_build_correct_url_using_verbose
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--verbose"]
    invoke_command('app', 'list', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")
  end

  # app add

  def test_add_command_should_build_correct_url
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--app=live"]
    invoke_command('app', 'add', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/addApp?apswd=secret&auser=fms&app=live")
  end

  # app reload

  def test_reload_command_should_build_correct_url
    options = ["--host=fms.example.com:1111",
               "--user=fms",
               "--password=secret",
               "--app=live"]
    invoke_command('app', 'reload', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/reloadApp?apswd=secret&auser=fms&appInst=live")
  end

  # app stats

  def test_stats_command_should_build_the_correct_url
    options = ["--host=fms.example.com:1111", 
               "--user=fms", 
               "--password=secret",
               "--app=live"]
    invoke_command('app', 'stats', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/getAppStats?apswd=secret&auser=fms&app=live")
  end

  # app unload

  def test_unload_command_should_build_correct_url
    options =   ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret",
                 "--app=live"]
    invoke_command('app', 'unload', options)
    assert_requested(:get, "http://fms.example.com:1111/admin/unloadApp?apswd=secret&auser=fms&appInst=live")
  end

end
