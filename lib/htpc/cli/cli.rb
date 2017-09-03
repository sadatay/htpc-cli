require_rel 'operations'
require_rel 'compositions'
require_rel 'commands'

module Htpc
  module CLI
    class Main < Compositions::Base
      # Global Flags #
      option ["-v", "--verbose"], :flag,
        "[Verbose]: Command output is more detailed"

      option ["--dry-run"], :flag,
        "[Dry Run]: Commands are shown but not executed"

      option ["--version"], :flag,
        "[Version]: Print version and exit" do
        puts "htpc-cli-#{Htpc::VERSION}"
        exit(0)
      end

      # Global Options #
      option "--config", "CONFIG", 
        "[Config]: Configuration file",
          :default => "#{File.expand_path('~')}/.htpc/config.yml"

      # Override of `Clamp::Command.run` with
      # an added entrypoint for global configuration
      def run(arguments)
        parse(arguments)
        configure
        execute
      end

      def configure
        configatron.home = File.expand_path('~')
        configatron.configure_from_hash(Psych.load_file(config))
      end

      # Command Manifest #
      subcommand "stage", "Manage Staging", Compositions::Base do
        subcommand "lint", "Lint items in staging", Htpc::CLI::Commands::Stage::Lint
        subcommand "add", "Add items to Staging", Htpc::CLI::Commands::Stage::Add
      end
    end
  end
end
