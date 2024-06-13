# frozen_string_literal: true

require_relative 'specimen_project_config'

module Specimen
  module Generator
    class SpecimenProject < Commands::BaseGroupCommand
      include Generator

      argument :project_options

      def self.source_root
        "#{File.dirname(__FILE__)}/templates"
      end

      def initialize(_, _, _)
        super
        @opts = project_options.to_h.deep_symbolize_keys
      end

      def start
        say('Initialize new Specimen project', Color::BOLD)

        @opts[:project_name].empty? ? ask_for_name : @opts[:project_name]
        @opts[:destination_root] = destination_root
        @config = SpecimenProjectConfig.new(@opts)
      end

      def execute
        empty_directory(@config.project_name)
        create_root_files

        inside @config.project_root do
          if @config.cucumber?
            empty_directory('features/step_definitions')
            empty_directory('features/support')
          end

          empty_directory('spec/support')
        end
      end

      def finish
        say("created new Specimen project in #{@config.project_root}", Color::GREEN)
      end

      no_commands do
        def ask_for_name
          @opts[:project_name] = ask('What is the name of the project?')
        end

        def create_root_files
          project_root_files.each do |file|
            source = file.start_with?('.') ? file.delete_prefix('.') : file
            create_file_by_template(source, "#{@config.project_root}/#{file}", @config.data)
          end
        end

        def project_root_files
          %w[.gemrc
             .rbenv-gemsets
             .rubocop.yml
             Gemfile
             README.md
             specimen.yml]
        end
      end
    end
  end
end
