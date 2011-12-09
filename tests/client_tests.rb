require 'tests_helper'

class ClientTests < BaseTestCase

  def test_should_require_host_parameter_and_provide_defaults_to_others
    c = FMS::Client.new(:host => "fms.example.com")
    assert_equal("fms.example.com", c.host)
    assert_equal(1111, c.port)
    assert_equal({:auser => "fms", :apswd => "fms"}, c.base_params)
  end

  def test_should_raise_error_if_host_not_provided
    assert_raises(ArgumentError) { FMS::Client.new }
  end

  def test_should_build_url_based_on_method_name
    c = FMS::Client.new(:host => "fms.example.com",
                        :apswd => "secret")
    c.get_apps
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms")
  end

  def test_should_use_params_to_build_url
    c = FMS::Client.new(:host => 'fms.example.com')
    c.get_apps(:force => true, :verbose => false)
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms&force=true&verbose=false")
  end

  def test_should_camelize_parameters_to_build_url
    c = FMS::Client.new(:host => 'fms.example.com')
    c.reload_app(:app_inst => 'live/cam1')
    assert_requested(:get, "http://fms.example.com:1111/admin/reloadApp?appInst=live/cam1&apswd=fms&auser=fms")
  end

end
