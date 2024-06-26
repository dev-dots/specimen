# frozen_string_literal: true

module Specimen
  module Generator
    class CucumberProjectGenerator < ProjectGeneratorBase
      DEFAULT_DIRECTORIES = %w[features/examples features/step_definitions/examples features/support].freeze
      TEMPLATES_DIR = 'cucumber/templates'
      TEMPLATES = %w[
        features/examples/add_numbers.feature
        features/support/env.rb
        cucumber.yml
      ].freeze

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
