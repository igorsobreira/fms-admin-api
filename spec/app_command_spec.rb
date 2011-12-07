
require 'spec_helper'

describe 'AppCommand' do

  describe 'list' do

    it 'should build the correct url' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")

      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret"]
      invoke_command("app", "list", options).should 
    end

    it 'should build the correct url using force, verbose is implicit in this case' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=true&verbose=true")
      
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret",
                 "--force"]
      invoke_command("app", "list", options)
    end

    it 'should build the correct url using verbose' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")

      options = ["--host=fms.example.com:1111",
                 "--user=fms",
                 "--password=secret",
                 "--verbose"]
      invoke_command("app", "list", options)
    end

  end

end
