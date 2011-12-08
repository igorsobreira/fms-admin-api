require 'tests_helper'

class ApiMethodTests < BaseTestCase
  
  def setup
    stub_request(:get, /.*/)
  end

  def test_should_accept_host_user_password_with_default_port_and_build_params
    c = FMS::Client.new("fms.example.com", "fms", "secret")

    assert_equal("fms.example.com", c.host)
    assert_equal(1111, c.port)
    assert_equal({:auser => "fms", :apswd => "secret"}, c.params)
  end

  def test_should_customize_port
    c = FMS::Client.new("fms.example.com", "fms", "secret", 2222)

    assert_equal(2222, c.port)    
  end

  def test_get_apps_method_should_build_correct_url
    c = FMS::Client.new("fms.example.com", "fms", "secret")
    c.get_apps

    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms")
  end

end
