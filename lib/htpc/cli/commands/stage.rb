module Htpc
  module CLI
    module Commands
      class Stage < Base
        subcommand "add", "Add items to staging zone" do
          parameter "ITEMS ...", "Manage staging zone", :attribute_name => :items do |item|
            Htpc::Models::Item.new(item)
          end

          def execute
            newline
            put_command "STAGING ITEMS"

            # REJECT INVALID ITEMS #
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

            # COLLECTION STATISTICS #
            total_size = items.map(&:size).reduce(:+)

            # PRINT ITEMS MARKED FOR STAGING #
            newline
            items_header = "#{pastel.bold("Items Marked For Staging (#{pastel.yellow(items.length)})")}"
            size_header = "#{pastel.bold("Size (#{pastel.yellow(human_size(total_size))})")}"
            torrent_header = "#{pastel.bold('Torrent Info')}"
            items_table = TTY::Table.new header: [items_header, size_header, torrent_header] do |table_row|
              items.each do |item|
                table_row << [
                  {value: " #{item.media_icon}  #{pastel.dim(truncate(item.to_s))}", alignment: :left},
                  {value: "#{item.icon}  #{item.human_size}", alignment: :center},
                  {value: "#{item.torrent.slug}", alignment: :center}
                ]
              end
            end
            puts items_table.render(:unicode, indent: 2, width: 120, resize: true) { |renderer|
              renderer.alignments = [:center, :center, :center]
              renderer.border.separator = :each_row
              renderer.border.style = :blue
            }

            # PROMPT TO PROCEED #
            newline
            exit(0) unless prompt.yes?("#{prompt_mark} Proceed with Staging?")

            # REMOVE TORRENTS FROM CLIENT #
            newline
            put_info 'Removing Torrents';
            items.select(&:has_torrent?).each do |item|
              spinner = TTY::Spinner.new(
                "[ :spinner ] #{pastel.dim(item)}",
                format: :dots,
                success_mark: success_mark,
                error_mark: failure_mark
              )
              spinner.run do
                if shell.run!("rtcontrol --delete --yes \"#{item.for_rtcontrol}\"").failure?
                  spinner.error
                else
                  spinner.success
                end
              end
            end

            # MOVE ITEMS TO STAGING ZONE #
            newline
            put_info 'Moving Items to Staging Zone';
            items.each do |item|
              spinner = TTY::Spinner.new(
                "[ :spinner ] #{pastel.bold(item.dirname)}/#{pastel.dim(truncate(item.to_s))} " \
                "→ #{pastel.yellow.bold($stage.path)}/#{pastel.dim(truncate(item.to_s))}",
                format: :dots,
                success_mark: success_mark,
                error_mark: failure_mark
              )
              spinner.run do
                shell.run("mv \"#{item.path}\" #{$stage.path}/")
                spinner.success
              end
            end
          end
        end
      end
    end
  end
end