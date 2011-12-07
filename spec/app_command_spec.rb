
require 'spec_helper'

describe 'AppCommand' do

  describe 'list' do

    it 'should build the correct url' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")

      args = ["list"]
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret"]

      cli = FMSAdmin::CLI.new(args, options)
      cli.invoke(FMSAdmin::Command::App, args)
    end

    it 'should build the correct url using force, verbose is implicit in this case' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=true&verbose=true")
      
      args = ["list"]
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret",
                 "--force"]

      cli = FMSAdmin::CLI.new(args, options)
      cli.invoke(FMSAdmin::Command::App, args)
    end

    it 'should build the correct url using verbose' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms&force=false&verbose=true")

      args = ["list"]
      options = ["--host=fms.example.com:1111",
                 "--user=fms",
                 "--password=secret",
                 "--verbose"]

      cli = FMSAdmin::CLI.new(args, options)
      cli.invoke(FMSAdmin::Command::App, args)
    end

  end

end
