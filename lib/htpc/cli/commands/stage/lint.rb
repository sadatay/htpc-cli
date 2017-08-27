module Htpc
  module CLI
    module Commands
      module Stage
        class Lint < Htpc::CLI::Commands::Compositions::Base
          parameter "ITEMS ...", "Items to lint", :attribute_name => :item_args
          attr_reader :torrent_service
          attr_accessor :items

          def init
            newline
            put_command "LINTING ITEMS"
          end

          def receive
            @items = item_args.map do |item_arg|
              Htpc::Models::Item.new(item: item_arg)
            end
          end

          def validate
            if items.any? { |item| !item.valid? }
              newline
              items.each do |item|
                if !item.valid?
                  put_warning "Skipping invalid item #{pastel.dim(item)}"
                end
              end
              items.reject! { |item| !item.valid? }
            end
            exit(0) if items.empty?
          end

          def action
            put_info "LINT ACTION"
          end

        end
      end
    end
  end
end