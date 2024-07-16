# frozen_string_literal: true

module Specimen
  module Command
    class ExecCommandBuilder
      VALID_FRAMEWORKS = %w[cucumber rspec]

      attr_reader :profile_data, :framework, :command, :runtime

      def self.build_exec_cmd!
        new.build_cmd
      end

      def initialize
        @runtime = Specimen.runtime
        @profile_data = runtime.profile_data
        @framework = runtime.framework
        @command = runtime.command
        @tests_path = command&.tests_path || ''
      end

      def build_cmd
        raise "Invalid framework '#{framework}'" unless VALID_FRAMEWORKS.include?(framework)

        cmd_str = ''.dup
        cmd_str << env_string unless env_string.empty?
        cmd_str << framework.dup.prepend(' ')
        cmd_str << options_string.prepend(' ') unless options_string.empty?
        cmd_str << tags_string.prepend(' ') unless tags_string.empty?
        cmd_str << @tests_path.dup.prepend(' ') unless @tests_path.empty?

        cmd_str.strip
      end

      def env_vars
        profile_data['env'] || []
      end

      def command_options
        profile_data['options'] || []
      end

      def profile_tags
        profile_data['tags'] || []
      end

      def command_tags
        command&.options[:tags] || []
      end

      def tags_string
        str = ''.dup
        all_tags = profile_tags.concat(command_tags)

        return '' if all_tags.empty?

        # '-t' option works for both Cucumber and RSpec
        all_tags.each { |tag| str << "-t \"#{tag}\" " }
        str.rstrip
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
