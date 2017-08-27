module Htpc
  module CLI
    module Commands
      module Stage
        class Add < Htpc::CLI::Commands::Compositions::Base
          parameter "ITEMS ...", "Items to add to staging zone", :attribute_name => :item_args
          attr_reader :torrent_service
          attr_accessor :items

          def init
            newline
            put_command "STAGING ITEMS"

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

          def compose
            newline

            spinner = TTY::Spinner.new(
              "#{pastel.blue.bold('[INFO]')} [ :spinner ] :status",
              format: :dots,
              success_mark: success_mark,
              error_mark: failure_mark
            )
            spinner.run do
              spinner.update(status: "#{pastel.bold('Loading Torrent Data')}")

              benchmark = Benchmark.measure do
                torrent_service.load_torrents!
              end

              seconds = "%ds" % benchmark.real

              spinner.update(
                status: "#{pastel.bold('Loaded')} " \
                  "#{pastel.yellow.bold(torrent_service.count)} " \
                  "#{pastel.bold('Torrents [')} #{pastel.dim(seconds)} " \
                  "#{pastel.bold(']')}"
              )
              spinner.success
            end

            items.each do |item|
              item.torrent = torrent_service.find_by_path(item.path)
            end
          end

          def before_action_operations
            [
              Htpc::CLI::Operations::ItemsTable.new(
                items: items,
                columns: [:size, :torrent_info]
              ),
              Htpc::CLI::Operations::ConfirmationPrompt.new(
                text: "#{prompt_mark} Proceed with Staging?"
              )
            ]
          end

          def action
            # REMOVE TORRENTS FROM CLIENT #
            newline
            put_info 'Removing Torrents';
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

            # MOVE ITEMS TO STAGING ZONE #
            newline
            put_info 'Moving Items to Staging Zone';
            items.each do |item|
              spinner = TTY::Spinner.new(
                "[ :spinner ] #{pastel.bold(item.dirname)}/#{pastel.dim(truncate(item.to_s))} " \
                "→ #{pastel.yellow.bold($stage.path)}/#{pastel.dim(truncate(item.to_s))}",
                format: :dots,
                success_mark: success_mark,
                error_mark: failure_mark
              )
              spinner.run do
                shell.run("mv \"#{item.path}\" #{$stage.path}/")
                spinner.success
              end
            end
          end

        end
      end
    end
  end
end