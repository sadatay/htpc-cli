module Htpc
  module CLI
    module Commands
      module Compositions
        class Base < Clamp::Command
          include Htpc::Utils::UI

          attr_accessor :command_info, :before_action_operations, :after_action_operations

          # Command "compositions" are abstract classes that lay
          # out the skeleton of a command's implementation.  This is
          # sometimes called the "template method" pattern.  Extracting
          # the shared control flow gives us a relatively uniform
          # structure across sets of similar commands. 
          def execute
            init
            receive
            validate
            compose
            before_action
            action
            after_action
          end

          def init; end
          def receive; end
          def validate; end
          def compose; end
          def action; end

          # These methods can be implemented in subclasses to inject
          # behavior via "operations" objects.  Their implementations
          # should return an array of operation objects, each of which
          # must provide an operate() method.
          def before_action_operations; end
          def after_action_operations; end

          def before_action
            Array(before_action_operations).each do |operation|
              operation.operate
            end
          end

          def after_action
            Array(after_action_operations).each do |operation|
              operation.operate
            end
          end
        end
      end
    end
  end
end

