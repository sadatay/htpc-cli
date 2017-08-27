module Htpc
  module Services
    class TorrentService
      include Htpc::Utils::Console

      attr_reader :torrents, :fields

      # TODO: this loads super slow.  we should have
      # a full format and a minimal format
      FIELDS = 

      def initialize(output_format: :minimal)
        @torrents = []
        @fields = output_formats(output_format)
        # binding.pry
      end

      def load_torrents!
        result = shell.run!("rtcontrol --json -q -o#{fields.join(',')} \"name=*\"")
        return nil unless result.err.empty? && !result.out.empty?

        data_hashes = MultiJson.load(result.out, symbolize_keys: true).to_hashugar
        @torrents = data_hashes.map do |data_hash|
          Htpc::Models::Torrent.new(data_hash)
        end

        return torrents
      end

      def count
        torrents.length
      end

      def find_by_path(path)
        torrents.find { |torrent| torrent.path == path }
      end

      private

      def output_formats(output_format)
        formats = {
          minimal: %w(
            alias done fno hash is_complete name path 
            realpath ratio size traits
          ),
          complete: %w(
            alias completed directory done down files
            fno hash is_active is_complete is_multi_file
            is_private kind leechtime message metafile name
            path realpath ratio size started tagged tracker
            traits up uploaded
          )
        }

        return formats[output_format]
      end
    end
  end
end
