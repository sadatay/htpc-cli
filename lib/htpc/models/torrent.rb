module Htpc
  module Models
    class Torrent
      include Htpc::Utils::Console

      # attr_reader :pastel, :shell
      attr_accessor :data

      TRACKERS = {
        "passthepopcorn.me": "PTP",
        "bitmetv.org": "BTV",
        "tv-vault.me": "TVV",
        "myspleen.org": "MYS",
        "apollo.rip": "APL",
        "flacsfor.me": "RED",
        "sceneaccess.eu": "SCC"
      }

      def initialize(data)
        # TODO: these should really be something
        # close to global.  If we have 1000 torrents now we have
        # 1000 TTY::Command objects?
        @data = data
      end

      # Delegate properties to `data` object
      def method_missing(sym, *args, &block)
        data.send sym, *args, &block
      end

      def delete!
        # TODO: hash is a reserved word, need to alias properties
        shell.run!("rtcontrol --delete --yes \"hash=#{data['hash']}\"")
      end

      def slug
        # TODO: gotta be a better way
        percent_complete = data.done
        tracker_decorated = TRACKERS[data.alias.to_sym] || "???"
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
      end
    end
  end
end
