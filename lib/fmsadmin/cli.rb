require 'thor'
require 'thor/group'

require 'fmsadmin/command'

module FMSAdmin

  class CLI < Thor

    desc "app", "Manager applications and instances"
    subcommand "app", FMSAdmin::Command::App

  end

end
