require 'tests_helper'

class ApiMethodTests < BaseTestCase
  
  def setup
    stub_request(:get, /.*/)
  end

  def test_get_apps_method_should_build_correct_url
    c = FMS::Client.new("fms.example.com", "fms", "secret")
    c.get_apps

    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms")
  end

end
