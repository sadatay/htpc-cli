module Htpc
  module CLI
    module Commands
      module Stage
        class Lint < Htpc::CLI::Compositions::Processor
          parameter "ITEMS ...", "Items to lint", :attribute_name => :items
          attr_accessor :items


          def receive
            newline
            put_command "LINTING ITEMS"

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

          def process
            put_info "LINT ACTION"
          end
        end
      end
    end
  end
end