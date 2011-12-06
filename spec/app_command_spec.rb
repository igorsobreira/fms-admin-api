
require 'spec_helper'

describe 'AppCommand' do

  describe 'list' do

    it 'should build the correct url' do
      stub_request(:get, "http://fms.example.com:1111/admin/getApps?apswd=secret&auser=fms")

      args = ["list"]
      options = ["--host=fms.example.com:1111", 
                 "--user=fms", 
                 "--password=secret"]

      cli = FMSAdmin::CLI.new(args, options)
      cli.invoke(FMSAdmin::Command::App, args)
    end

  end

end
