# frozen_string_literal: true

module Specimen
  module Generator
    class SpecimenProjectGenerator < GeneratorBase
      def execute!
        perform
      end

      no_commands do
        def perform
          ProjectRootGenerator.start([config])
          CucumberProjectGenerator.start([config]) if config[:cucumber]
          RSpecProjectGenerator.start([config]) if config[:rspec]

          true
        end

        def config
          @config ||= Generator::SpecimenProjectConfig.parse(options)
        end
      end
    end
  end
end
