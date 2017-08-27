require 'find'
require 'filesize'

module Htpc
  module Models
    class Item
      include Htpc::Utils::Console
      extend Forwardable

      attr_accessor :torrent
      attr_reader :pathname
      
      def_delegators :pathname, :file?, :directory?, :basename, :dirname, :realpath

      def initialize(item:, torrent: nil)
        @pathname = Pathname.new(item)
        @torrent = torrent
      end

      def path
        pathname.realpath.to_s
      end

      def valid?
        pathname.exist?
      end

      def to_s
        basename.to_s
      end

      def has_torrent?
        torrent ? true : false
      end

      def delete_torrent!
        torrent.delete!
        torrent = nil
      end

      def torrent_slug
        torrent ? torrent.slug : "[ #{pastel.red('NOT TRACKED')} ]"
      end

      def icon
        # TODO: account for 
        file? ? "\u{f015}" : "\u{f113}"
      end

      def media_icon
        if torrent && torrent.traits
          case
          when torrent.traits.include?('video')
            "\u{f007}"
          when torrent.traits.include?('audio')
            "\u{f484}"
          when torrent.traits.include?('docs')
            "\u{f02c}"
          else
            "\u{f0c6}"
          end
        else
          # TODO: fallback to mediainfo
          "\u{f0c6}"
        end
      end

      def size
        Find.find(path).map do |item|
          Pathname.new(item).size
        end.reduce(:+)
      end

      def human_size
        Filesize.new(size, Filesize::SI).pretty
      end
    end
  end
end
