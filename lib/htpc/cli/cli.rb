# require 'clamp'
# require 'htpc/cli/commands/stage.rb'
require 'htpc/cli/utils/ui.rb'
require 'htpc/cli/commands/base.rb'
require 'htpc/cli/commands/stage.rb'

module Htpc
  module CLI
    class Main < Clamp::Command
      option ["-v", "--verbose"], :flag, "be verbose"

      option "--version", :flag, "show version" do
        puts "htpc-cli-#{Htpc::VERSION}"
        exit(0)
      end

      subcommand "stage", "Manage Staging", Htpc::CLI::Commands::Stage
    end
  end
end
