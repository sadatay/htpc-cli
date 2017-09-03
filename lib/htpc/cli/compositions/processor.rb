module Htpc
  module CLI
    module Compositions
      class Processor < Base

        def execute
          init
          receive
          validate
          process
          resolve
        end

        def receive; end
        def validate; end
        def process; end
        def resolve; end


        def operations; end

        def process
          # TODO: take a block?
          Array(operations).each do |operation|
            newline
            operation.describe if operation.respond_to?(:describe)
            operation.operate
          end
        end
      end
    end
  end
end

