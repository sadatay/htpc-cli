module Htpc
  module CLI
    module Operations
      class DisplayItemsTable
        include Htpc::Utils::UI
        attr_reader :items, :columns, :headers, :alignments, :column_specs, :total_size

        def initialize(items:, columns:)
          @items = items
          @columns = columns.unshift(:item)

          @total_size = items.map(&:size).reduce(:+)

          @headers = columns.map do |column|
            column_specs[column].header
          end

          @alignments = columns.map do |column|
            column_specs[column].alignments.header
          end
        end

        def operate
          items_table = TTY::Table.new header: headers do |table_row|
            items.each do |item|
              table_row << [
                { value: column_specs[:item].value.call(item), alignment: column_specs[:item].alignments.value },
                { value: column_specs[:size].value.call(item), alignment: column_specs[:size].alignments.value },
                { value: column_specs[:torrent_info].value.call(item), alignment: column_specs[:torrent_info].alignments.value },
              ]
            end
          end
          newline
          puts items_table.render(:unicode, indent: 2, width: 120, resize: true) { |renderer|
            renderer.alignments = alignments
            renderer.border.separator = :each_row
            renderer.border.style = :blue
          }
        end

        private

        def column_specs
          return Hashugar.new(
            {
              item: {
                header: "#{pastel.bold("Items Marked For Staging (#{pastel.yellow(items.length)})")}",
                value: Proc.new { |item| " #{item.media_icon}  #{pastel.dim(truncate(item.to_s))}" },
                alignments: {
                  header: :center,
                  value: :left
                }
              },
              size: {
                header: "#{pastel.bold("Size (#{pastel.yellow(human_size(total_size))})")}",
                value: Proc.new { |item| "#{item.icon}  #{item.human_size}" },
                alignments: {
                  header: :center,
                  value: :center
                }
              },
              torrent_info: {
                header: "#{pastel.bold('Torrent Info')}",
                value: Proc.new { |item| "#{item.torrent_slug}" },
                alignments: {
                  header: :center,
                  value: :center
                }
              }
            }
          )
        end
      end
    end
  end
end