module Htpc
  module CLI
    module Commands
      module Stage
        class Add < Htpc::CLI::Compositions::Processor
          
          # Params #
          parameter "ITEMS ...", "Items to add to staging zone", :attribute_name => :item_args
          
          attr_accessor :items, :torrent_service

          def init
            newline
            put_command "Staging Items"

            @torrent_service = Htpc::Services::TorrentService.new
          end

          def receive
            @items = item_args.map do |item_arg|
              Htpc::Models::Item.new(item: item_arg)
            end
          end

          def validate
            if items.any? { |item| !item.valid? }
              newline
              items.each do |item|
                if !item.valid?
                  put_warning "Skipping invalid item #{pastel.dim(item)}"
                end
              end
              items.reject! { |item| !item.valid? }
            end
            exit(0) if items.empty?
          end

          def operations
            [
              Htpc::CLI::Operations::LoadTorrentsForItems.new(
                items: items,
                torrent_service: torrent_service
              ),
              Htpc::CLI::Operations::DisplayItemsTable.new(
                items: items,
                columns: [:size, :torrent_info]
              ),
              Htpc::CLI::Operations::DisplayConfirmationPrompt.new(
                text: "#{prompt_mark} Proceed with Staging?"
              ),
              Htpc::CLI::Operations::RemoveTorrentsForItems.new(
                items: items,
              ),
              Htpc::CLI::Operations::MoveItems.new(
                items: items,
                destination: configatron.stage.path
              )
            ]
          end
        end
      end
    end
  end
end