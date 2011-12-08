require 'minitest/autorun'
require 'webmock'

require 'fms'

class BaseTestCase < MiniTest::Unit::TestCase
  include WebMock::API
end
