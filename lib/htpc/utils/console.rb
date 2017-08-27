module Htpc
  module Utils
    module Console
      # TTY Controls #
      def pastel
        @pastel ||= Pastel.new
      end
      def prompt
        @prompt ||= TTY::Prompt.new
      end
      def shell
        @shell ||= TTY::Command.new(dry_run: false, printer: :null)
      end
      def dry_run
        @dry_run ||= TTY::Command.new(dry_run: true)
      end
    end
  end
end