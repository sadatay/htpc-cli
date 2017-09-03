module Htpc
  module CLI
    module Operations
      class MoveItems
        include Htpc::Utils::UI
        attr_reader :items, :destination

        def initialize(items:, destination:)
          @items = items
          @destination = destination
        end

        def describe
          put_info 'Moving Items to Staging Zone'
        end

        def operate
          items.each do |item|
            spinner = TTY::Spinner.new(
              "[ :spinner ] #{pastel.bold(item.dirname)}/#{pastel.dim(truncate(item.to_s))} " \
              "→ #{pastel.yellow.bold(destination)}/#{pastel.dim(truncate(item.to_s))}",
              format: :dots,
              success_mark: success_mark,
              error_mark: failure_mark
            )
            spinner.run do
              shell.run("mv \"#{item.path}\" #{destination}/")
              spinner.success
            end
          end
        end
      end
    end
  end
end
