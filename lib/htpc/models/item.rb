require 'find'
require 'filesize'
require 'htpc/cli/utils/ui.rb'

module Htpc
  module Models
    class Item
      extend Forwardable

      attr_reader :path, :pathname
      def_delegators :pathname, :file?, :directory?, :basename, :dirname

      def initialize(path)
        @path = path
        @pathname = Pathname.new(path)
      end

      def valid?
        pathname.exist?
      end

      def to_s
        basename.to_s
      end

      def for_rtcontrol
        basename.to_s.sub('[','?').sub(']','?').sub(',','?').sub('/','')
      end

      def icon
        # Returns a file glyph for bare files and a folder glyph
        # for directories.  Assumes "Font Awesome" is installed
        # (see https://github.com/ryanoasis/nerd-fonts).  We should
        # probably default to some plaintext if the unicode codepoints
        # come up empty for these on the user's system, but I'm not
        # sure how to check for that yet.
        file? ? "\u{f015}" : "\u{f113}"
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
