require 'minitest/autorun'
require 'webmock'
require 'mocha'

require 'fms'

class BaseTestCase < MiniTest::Unit::TestCase
  include WebMock::API

  def setup
    stub_request(:get, /.*/)
  end

  def teardown
    WebMock.reset!
  end

end
