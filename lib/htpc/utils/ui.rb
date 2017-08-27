module Htpc
  module Utils
    module UI
      include Htpc::Utils::Console

      # Colorized Notices #
      def put_info(text)
        puts "%s %s" % [pastel.blue.bold("[INFO]"), pastel.bold(text)]
      end
      def put_warning(text)
        puts "%s %s" % [pastel.yellow.bold("[WARNING]"), pastel.bold(text)]
      end
      def put_error(text)
        puts "%s %s" % [pastel.red.bold("[ERROR]"), pastel.bold(text)]
      end
      def put_success(text)
        puts "%s %s" % [pastel.green.bold("[SUCCESS]"), pastel.bold(text)]
      end
      def put_command(text)
        puts "%s %s" % [pastel.cyan.bold("[COMMAND]"), pastel.bold(text)]
      end
      def put_bullet(text, level=1)
        indent = "  " * level
        puts "%s↳ #{pastel.blue.bold('[')} %s #{pastel.blue.bold(']')}" % [indent, pastel.dim(text)]
      end

      # Colorized Glyphs #
      def success_mark
        pastel.green.bold("✔")
      end
      def failure_mark
        pastel.red.bold("✘")
      end
      def prompt_mark
        pastel.magenta.bold("[PROMPT]")
      end

      # Formatters #
      def human_size(size)
        Filesize.new(size, Filesize::SI).pretty
      end

      def truncate(text, length = 40, ellipsis = '...')
        if text.length > length
          text.to_s[0..length].gsub(/[^\w]\w+\s*$/, ellipsis)
        else
          text
        end
      end

      # Misc #
      def newline
        puts "\n"
      end
    end
  end
end
