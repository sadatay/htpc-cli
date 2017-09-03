module Htpc
  module CLI
    module Operations
      class LoadTorrentsForItems
        include Htpc::Utils::UI
        attr_reader :items, :torrent_service

        def initialize(items:, torrent_service:)
          @items = items
          @torrent_service = torrent_service || Htpc::Services::TorrentService.new
        end

        def operate
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
      end
    end
  end
end
