require_rel 'stage'

module Htpc
  module CLI
    module Commands
      module Stage
        class Main < Clamp::Command
          subcommand "lint", "Lint items in staging", Htpc::CLI::Commands::Stage::Lint
          subcommand "add", "Add items to Staging", Htpc::CLI::Commands::Stage::Add
        end
      end
    end
  end
end