module Htpc
  module CLI
    module Commands  
      class Base < Clamp::Command
        include Htpc::CLI::Utils::UI
      end
    end
  end
end