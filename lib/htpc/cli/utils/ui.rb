module Htpc
  module CLI
    module Utils
      module UI
        # TTY Control #
        def pastel
          @pastel ||= Pastel.new
        end
        def prompt
          @prompt ||= TTY::Prompt.new
        end

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
      end
    end
  end
end
