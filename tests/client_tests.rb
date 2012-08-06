require 'rexml/xpath'
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

  def test_should_return_response_as_xml
    url = "http://fms.example.com:1111/admin/getLiveStreamStats?appInst=live&apswd=fms&auser=fms&stream=cam1"
    stub_request(:get, url).to_return(:body => GET_LIVE_STREAM_STATS)

    c = FMS::Client.new(:host => 'fms.example.com')
    xml_resp = c.get_live_stream_stats(:app_inst => 'live', :stream => 'cam1').to_xml

    assert_requested(:get, url)
    assert_equal "cam1", REXML::XPath.first(xml_resp, '/result/data/publisher/name').text
  end

  def test_should_return_response_as_raw_string
    url = "http://fms.example.com:1111/admin/getLiveStreamStats?appInst=live&apswd=fms&auser=fms&stream=cam1"
    stub_request(:get, url).to_return(:body => GET_LIVE_STREAM_STATS)

    c = FMS::Client.new(:host => 'fms.example.com')
    str_resp = c.get_live_stream_stats(:app_inst => 'live', :stream => 'cam1').to_s

    assert_requested(:get, url)
    assert str_resp.include?('<name>cam1</name>')
  end

  def test_should_use_timeout_param
    c = FMS::Client.new(:host => 'fms.example.com', :timeout => 3)
    c.get_apps
    assert_requested(:get, "http://fms.example.com:1111/admin/getApps?apswd=fms&auser=fms")
  end

  def test_should_respect_timeout_param
    httpclient_mock = mock()
    response_stub = stub(:code => "200", :body => "")
    FMS::HTTPClient.expects(:new).with('fms.example.com', 1111).returns(httpclient_mock)
    httpclient_mock.expects(:get).with('/admin/getApps?auser=fms&apswd=fms', 123).returns(response_stub)

    c = FMS::Client.new(:host => 'fms.example.com', :timeout => 123)
    c.get_apps
  end

end

# Stub responses

GET_LIVE_STREAM_STATS = %Q{
<?xml version="1.0" encoding="utf-8"?>
<result>
  <level>status</level>
  <code>NetConnection.Call.Success</code>
  <timestamp>Mon May 14 22:44:35 2012</timestamp>
  <data>
    <name>_defaultRoot_:_defaultVHost_:::_0</name>
    <publisher>
      <name>cam1</name>
      <time>Mon May 14 22:43:39 2012</time>
      <type>publishing</type>
      <client>oAACAAAA</client>
      <stream_id>ACACAAAA</stream_id>
      <client_type>normal</client_type>
      <diffserv_bits>0x0</diffserv_bits>
      <publish_time>Mon May 14 22:43:39 2012</publish_time>
    </publisher>
    <subscribers>
    </subscribers>
  </data>
</result>
}
