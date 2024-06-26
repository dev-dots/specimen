# frozen_string_literal: true

module Specimen
  module Config
    class PathConfig
      class MissingSpecimenYamlError < RuntimeError; end
      class NotADirectoryError < RuntimeError; end

      attr_reader :config_file, :path

      def initialize(config_file:, path: '')
        @config_file = config_file
        @path = path
      end

      def configure!
        run_path_checks!
        self
      end

      def run_path_checks!
        raise NotADirectoryError, "'#{working_dir}' is not a directory!" unless working_dir.directory?
        raise MissingSpecimenYamlError, "Missing config file: '#{config_file_path}'!" unless config_file_path.exist?
      end

      def working_dir
        @working_dir ||= path.empty? ? Config.init_wd_path : Pathname.new("#{Dir.pwd}/#{root_path_name}")
      end

      def config_file_path
        @config_file_path ||= Pathname.new("#{working_dir.to_path}/#{config_file}")
      end

      def custom_config?
        config_file != 'specimen.yml'
      end

      def root_path_name
        split_paths.first
      end

      def split_paths
        path.split('/')
      end

      def tests_path
        @tests_path ||= split_paths.drop(1).join('/')
      end

      def tests_path?
        tests_path.empty?
      end

      def path?
        path.empty?
      end
    end
  end
end
