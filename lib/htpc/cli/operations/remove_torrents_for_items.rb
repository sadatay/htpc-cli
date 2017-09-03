module Htpc
  module CLI
    module Operations
      class RemoveTorrentsForItems
        include Htpc::Utils::UI
        attr_reader :items

        def initialize(items:)
          @items = items
        end

        def describe
          put_info 'Removing Torrents'
        end

        def operate
          items.select(&:has_torrent?).each do |item|
            spinner = TTY::Spinner.new(
              "[ :spinner ] #{pastel.dim(item)}",
              format: :dots,
              success_mark: success_mark,
              error_mark: failure_mark
            )
            spinner.run do
              item.delete_torrent!
              spinner.success
            end
          end
        end
      end
    end
  end
end
