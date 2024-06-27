# frozen_string_literal: true

module Specimen
  module Generator
    class ProjectRootGenerator < ProjectGeneratorBase
      DEFAULT_DIRECTORIES = %w[config lib tmp].freeze
      TEMPLATES_DIR = 'project/templates/root'
      TEMPLATES = %w[
        .gemrc
        .gitignore
        .rubocop.yml
        Gemfile
        README.md
        config/specimen.yml
      ].freeze

      #  argument :config

      def execute!
        perform
      end

      no_commands do
        def perform
          create_directories(DEFAULT_DIRECTORIES)
          create_files_by_templates(TEMPLATES_DIR, TEMPLATES)

          true
        end
      end
    end
  end
end
