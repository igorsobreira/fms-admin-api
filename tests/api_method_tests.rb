require 'tests_helper'

class ApiMethodTests < BaseTestCase

  def teardown
    if FMS::Client.instance_methods.include? :test_api_method_foo
      FMS::Client.del_api_method(:test_api_method_foo)
    end
  end
  
  def test_api_method_should_add_new_method_to_client_class
    refute_client_method(:test_api_method_foo)

    FMS::ApiMethod.new do |m| 
      m.name = 'test_api_method_foo'
      m.on_call {}
    end

    assert_client_method(:test_api_method_foo)
  end

  def test_client_should_call_block_defined_on_on_call
    called = false
    FMS::ApiMethod.new do |m|
      m.name = 'test_api_method_foo'
      m.on_call { called = true }
    end

    c = FMS::Client.new "host", "user", "passwd"
    c.test_api_method_foo

    assert called
  end

  # specific asserts

  def refute_client_method(method)
    refute_includes(FMS::Client.instance_methods.sort, method,
                    "Expect #{method.to_sym.inspect} to NOT be defined on FMS::Client")
  end

  def assert_client_method(method)
    assert_includes(FMS::Client.instance_methods.sort, method,
                    "Expect #{method.to_sym.inspect} to be defined on FMS::Client")
  end

end
