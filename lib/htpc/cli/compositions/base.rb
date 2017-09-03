module Htpc
  module CLI
    module Compositions
      class Base < Clamp::Command
        include Htpc::Utils::UI
      end
    end
  end
end