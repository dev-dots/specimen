# frozen_string_literal: true

module Specimen
  module Command
    class CommandBuilder
      attr_reader :settings

      def initialize(settings)
        @settings = settings
      end

      def build_cmd
        "#{env_string} #{base_cmd} #{options_string} #{tests_path}".strip
      end

      def base_cmd
        settings['framework']
      end

      def tests_path
        settings['tests_path']
      end

      def env_vars
        settings['env_vars'] || {}
      end

      def command_options
        settings['command_options'] || []
      end

      def env_string
        return '' unless env_vars.any?

        str = ''.dup
        env_vars.each { |k, v| str << "#{k}='#{v}' " }
        str.rstrip
      end

      def options_string
        return '' unless command_options.any?

        str = ''.dup
        command_options.each { |opt| str << "#{opt} " }
        str.rstrip
      end
    end

    class CommonTestRunner < BaseGroup
      class_option :config_file, aliases: %w[-C --config], type: :string, default: 'specimen.yml'
      class_option :tests_path, aliases: %w[-P --path], type: :string, default: ''
      class_option :threads, type: :numeric, default: 1

      def execute!
        perform
      end

      no_commands do

        def perform
          binding.pry
          # run_tests!
        end

        def run_tests!

          success = inside runtime_settings['working_dir'] do
            run(exec_command)
          end

        end

        def framework
          nil
        end

        def profile
          ''
        end

        def path
          ''
        end

        def specimen_settings
          @specimen_settings ||= Config::SpecimenSettings.new(framework:, options:, path:, profile:)
        end

        def runtime_settings
          specimen_settings.runtime_settings
        end

        def exec_command
          CommandBuilder.new(runtime_settings).build_cmd
        end
      end
    end
  end
end
