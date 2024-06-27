# frozen_string_literal: true

require_relative 'runtime/yml_parser'

module Specimen
  module Runtime
    class MissingCommandOptionError < RuntimeError
      def initialize(command, option)
        @msg = "Command '#{command}' misses option: '#{option}'"
        super(@msg)
      end
    end

    class UndefinedYmlError < RuntimeError
      def initialize
        @msg = "Option '--config-fie' is not set!"
        super(@msg)
      end
    end

    class YmlNotFoundError < RuntimeError
      def initialize(yml_path)
        @msg = "No such file: '#{yml_path.to_path}'"
        super(@msg)
      end
    end

    DEFAULT_YML_NAME = 'specimen.yml'

    class << self
      attr_reader :command, :config

      def start!(command, **config)
        @command = command
        @config = config

        return if skip_yml_load?
        raise YmlNotFoundError, yml_path unless yml_path.exist?

        self
      end

      def work_dir
        @work_dir ||= Pathname.getwd
      end

      def config_dir
        @config_dir ||= Pathname.new("#{work_dir}/config")
      end

      def yml_path
        @yml_path ||= Pathname.new("#{config_dir}/#{yml_name}")
      end

      def skip_yml_load?
        command.is_a?(Command::InitCommand)
      end

      def yml_name
        return @yml_name if @yml_name

        key_name = 'config_file'
        raise MissingCommandOptionError, command, key_name unless command.options.key?(key_name)

        yml_name = command.options[key_name]
        raise UndefinedYmlError if yml_name.empty?

        @yml_name = yml_name
      end

      def yml_data
        @yml_data ||= YmlParser.parse!(yml_path.to_path)
      end

      def default_yml_data
        @default_yml_data ||= profile_yml_data('default')
      end

      def profile_yml_data(profile = nil)
        yml_data[profile]
      end
    end
  end
end
