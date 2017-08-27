require_rel 'operations'
require_rel 'commands'
require 'htpc/utils/ui.rb'

module Htpc
  module CLI
    class Main < Clamp::Command
      option ["-v", "--verbose"], :flag, "be verbose"
      option "--version", :flag, "show version" do
        puts "htpc-cli-#{Htpc::VERSION}"
        exit(0)
      end

      subcommand "stage", "Manage Staging", Htpc::CLI::Commands::Stage::Main
    end
  end
end
