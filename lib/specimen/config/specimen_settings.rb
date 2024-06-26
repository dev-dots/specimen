# frozen_string_literal: true

module Specimen
  module Config
    class SpecimenSettings
      attr_reader :options, :config_file, :path

      def initialize(framework:, options:, path: '', profile: '')
        @framework = framework
        @options = options
        @config_file = options[:config_file]
        @path = path
        @profile = profile
      end

      def runtime_settings
        @runtime_settings ||= {
          framework: exec_framework,
          working_dir: path_config.working_dir,
          tests_path: path_config.tests_path,
          framework_config: framework_config,
          command_options: framework_config['options'] || [],
          env_vars: framework_config['env'] || {},
          threads: parallel_threads,
          parallel: parallel_threads > 1
        }.deep_stringify_keys!
      end

      def parallel_threads
        return options[:threads] if framework?

        framework_config['threads'] || options[:threads]
      end

      def path_config
        @path_config ||= Config::PathConfig.new(config_file:, path:)
      end

      def yml_data
        @yml_data ||= Config::YmlParser.parse!(path_config.config_file_path)
      end

      def default_config
        yml_data['default']
      end

      def framework_config
        return yml_data[exec_framework] if framework?

        yml_data[@profile]
      end

      def framework?
        !@framework.nil?
      end

      def profile?
        !@profile.empty?
      end

      def exec_framework
        return @exec_framework if @exec_framework
        return @exec_framework = @framework if framework?

        raise 'Profile can not be empty..' unless profile?
        raise "Can not find profile #{@profile} in #{path_config.config_file_path}" unless yml_data.key?(@profile)
        raise "No exec framework defined for profile: #{@profile}" unless yml_data[@profile].key?('framework')

        frameworks = %w[cucumber rspec]
        framework = yml_data[@profile]['framework']

        raise "Invalid framework name: '#{framework}'!" unless frameworks.include?(framework)

        @exec_framework = framework
      end
    end
  end
end
