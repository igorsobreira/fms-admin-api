
require 'spec_helper'

describe 'AppCommand' do

  describe 'list' do

    it 'should build the correct url' do
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret"]

      ["app", "list", options].should build_url("http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")
    end

    it 'should build the correct url using force, verbose is implicit in this case' do
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret",
                 "--force"]

      ["app", "list", options].should build_url("http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=true&verbose=true")                   
    end

    it 'should build the correct url using verbose' do
      options = ["--host=fms.example.com:1111",
                 "--user=fms",
                 "--password=secret",
                 "--verbose"]

      ["app", "list", options].should build_url("http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")
    end

  end

end
