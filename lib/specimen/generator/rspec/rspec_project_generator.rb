# frozen_string_literal: true

module Specimen
  module Generator
    class RSpecProjectGenerator < ProjectGeneratorBase
      DEFAULT_DIRECTORIES = %w[spec/examples spec/support].freeze
      TEMPLATES_DIR = 'rspec/templates'
      TEMPLATES = %w[
        spec/examples/example_spec.rb
        spec/spec_helper.rb
        config/.rspec
        config/specimen.specs.yml
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
