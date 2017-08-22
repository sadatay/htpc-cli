require 'csv'
module Htpc
  module Models
    class Torrent

      attr_reader :name, :percent_complete, :ratio, :tracker, :traits, :pastel

      TRACKERS = {
        "passthepopcorn.me": "PTP",
        "bitmetv.org": "BTV",
        "tv-vault.me": "TVV",
        "myspleen.org": "MYS",
        "apollo.rip": "APL",
        "flacsfor.me": "RED",
        "sceneaccess.eu": "SCC"
      }

      def initialize(name:, directory:)
        @name = name
        @pastel ||= Pastel.new
        
        shell = TTY::Command.new(dry_run: false, printer: :null)
        out, err = shell.run!("rtcontrol -o '$(done)5.1f $(ratio)s $(alias)s $(traits)s \"$(realpath)s\"' \"#{sanitize(name)}\" | head -n -2 | grep --color=never \"#{directory}\"")
        
        if !err.empty? || out.empty?
          @exist = false
          return nil
        else
          @exist = true
        end

        data = CSV::parse_line(out, { col_sep: ' ' })
        @percent_complete = data[0]
        @ratio = data[1]
        @tracker = data[2]
        @traits = data[3]
      end

      def slug
        if exist?
          tracker_decorated = TRACKERS[tracker.to_sym] || "???"
          percent_decorated = percent_complete.to_i
          ratio_decorated = ratio.to_f

          case 
          when percent_complete.to_i == 100
            percent_decorated = "#{pastel.green(percent_complete)}%"
          when percent_complete.to_i == 0
            percent_decorated = "#{pastel.red(percent_complete)}%"
          else
            percent_decorated = "#{pastel.yellow(percent_complete)}%"
          end

          case 
          when ratio.to_f >= 1
            ratio_decorated = "#{pastel.green('%1.2f' % ratio.to_f)}"
          when ratio.to_f == 0
            ratio_decorated = "#{pastel.red('%1.2f' % ratio.to_f)}"
          else
            ratio_decorated = "#{pastel.yellow('%1.2f' % ratio.to_f)}"
          end

          return "[ \u{f0ab}  #{tracker_decorated} ] [ \u{f018}  #{percent_decorated} ] [ \u{2696}  #{ratio_decorated} ]"
        else
          return "[ #{pastel.red('NOT TRACKED')} ]"
        end
      end

      def exist?
        return @exist
      end

      def sanitize(input)
        input.sub('[','?').sub(']','?').sub(',','?').sub('/','')
      end
    end
  end
end
