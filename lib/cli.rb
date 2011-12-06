require 'thor'
require 'thor/group'
require_relative 'command/app'

module FMSAdmin

  class CLI < Thor

    desc "app", "Manager applications and instances"
    subcommand "app", FMSAdmin::Command::App

  end

end
