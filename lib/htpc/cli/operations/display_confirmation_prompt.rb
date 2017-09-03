module Htpc
  module CLI
    module Operations
      class DisplayConfirmationPrompt
        include Htpc::Utils::UI
        attr_reader :text

        def initialize(text: 'Proceed?')
          @text = text
        end

        def operate
          newline
          exit(0) unless prompt.yes?("#{prompt_mark} Proceed with Staging?")
        end
      end
    end
  end
end