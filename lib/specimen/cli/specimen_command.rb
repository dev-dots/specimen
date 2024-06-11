# frozen_string_literal: true

require 'specimen/generator'

module Specimen
  module CLI
    class SpecimenCommands < Commands::BaseCommand
      include Generator

      namespace :default

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.name}"
      end

      def self.source_root
        File.dirname(__FILE__)
      end

      desc 'init', 'Initialize a new Specimen project'

      method_option :project_name, aliases: %w[--name -n], type: :string, default: ''
      method_option :api_only, type: :boolean, default: false
      method_option :cucumber, type: :boolean, default: true

      def init
        SpecimenProject.start([options.dup])
      end

      desc 'commands', 'print all commands'

      def commands
        [SpecimenCommands].each { |cmd| cmd.new.help }
      end
    end
  end
end
