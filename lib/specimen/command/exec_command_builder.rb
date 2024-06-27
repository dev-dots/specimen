# frozen_string_literal: true

module Specimen
  module Command
    class ExecCommandBuilder
      attr_reader :config

      def initialize(config:, framework: nil, tests_path: '')
        @framework = framework
        @config = config
        @tests_path = tests_path
      end

      def build_cmd
        raise 'Undefined framework' if base_cmd.nil?

        "#{env_string} #{base_cmd} #{options_string} #{@tests_path}".strip
      end

      def base_cmd
        config['framework'] || @framework
      end

      def env_vars
        config['env'] || []
      end

      def command_options
        config['options'] || []
      end

      def env_string
        return '' unless env_vars.any?

        env_vars.join(' ')
      end

      def options_string
        return '' unless command_options.any?

        command_options.map(&:to_s).join(' ')
      end
    end


  end
end
