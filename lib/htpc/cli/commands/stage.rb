module Htpc
  module CLI
    module Commands
      class Stage < Base
        self.default_subcommand = "add"

        subcommand "add", "Add items to staging zone" do
          parameter "ITEMS ...", "Manage staging zone", :attribute_name => :items do |item|
            Htpc::Models::Item.new(item)
          end

          def execute
            put_command "STAGING ITEMS"

            # Validate
            items.reject! { |item| !item.valid? }

            # TTY UTILITIES #
            shell_command = TTY::Command.new(dry_run: true, printer: :null)
            items_table_header = "#{pastel.bold("Items (#{items.length})")}"
            deleted_table_header = "#{pastel.bold('Deleted')}"

            # ITEMS MARKED FOR STAGING #
            put_info 'Items Marked For Staging'
            items_table = TTY::Table.new header: [items_table_header] do |table_row|
              items.each do |item|
                table_row << [" - #{item}"]
              end
            end
            puts items_table.render(:unicode, indent: 7) { |renderer| 
              renderer.border.separator = :each_row
              renderer.border.style = :blue
            }

            # TODO: figure out how to properly exit
            exit(0) unless prompt.yes?("#{prompt_mark} Proceed with Staging?")

            # REMOVING TORRENTS #
            # TODO: only offer this if there's a torrent for item
            put_info 'Removing Torrents';
            torrent_table = TTY::Table.new(
              header: [
                items_table_header,
                deleted_table_header
              ]
            )
            items.each do |item|
              # TODO: spinner?
              if shell_command.run!("rtcontrol --delete --yes \"#{item.for_rtcontrol}\"").failure?
                torrent_table << [" - #{item}", { value: "#{failure_mark}", alignment: :center }]
              else
                torrent_table << [" - #{item}", { value: "#{success_mark}", alignment: :center }]
              end
            end
            puts torrent_table.render(:unicode, indent: 7) { |renderer| 
              renderer.border.separator = :each_row
              renderer.border.style = :blue
            }

            #################
            # STAGING ITEMS #
            #################
            put_info "#{pastel.bold("Moving Items to Staging Zone")} ( #{pastel.yellow($stage.path)} )";
            items.each do |item|
              spinner = TTY::Spinner.new("#{pastel.yellow.bold('⟦')} #{pastel.bold('SEED')} [:spinner] #{pastel.bold('STAGE')} #{pastel.yellow.bold('⟧')} #{item}", format: :arrow_pulse, success_mark: "#{pastel.green('▸▸▸▸▸')}")
              spinner.run do
                shell_command.run("mv \"#{item.path}\" #{$stage.path}/")
                spinner.success
              end
            end
          end
        end
      end
    end
  end
end