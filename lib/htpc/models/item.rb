module Htpc
  module Models
    class Item
      extend Forwardable

      attr_reader :path, :pathname
      def_delegators :pathname, :file?, :directory?, :basename

      def initialize(path)
        @path = path
        @pathname = Pathname.new(path)
      end

      # TODO: write a helper to get human readable
      # file or directory size, various other reporting?

      def valid?
        pathname.exist?
      end

      def to_s
        basename.to_s
      end

      def for_rtcontrol
        basename.to_s.sub('[','?').sub(']','?').sub(',','?').sub('/','')
      end
    end
  end
end