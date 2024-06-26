# frozen_string_literal: true

require 'colorize'

require 'specimen/command/base'
require 'specimen/command/base_group'
require 'specimen/command/commons/common_test_runner'

require 'specimen/commands/cukes/cukes_command'
require 'specimen/commands/exec/exec_command'
require 'specimen/commands/gem_help/gem_help_command'
require 'specimen/commands/init/init_command'
require 'specimen/commands/specs/specs_command'

module Specimen
  module Command
    class InvalidCommandError < RuntimeError; end

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :BaseGroup

    HELP_MAPPINGS = %w[-h -? --help].to_set
    COMMAND_MAPPINGS = %w[cukes exec init specs generate test].to_set

    class << self
      attr_reader :args, :config, :exec_config

      def default_config
        @default_config ||= {
          verbose: false,
          strict: false,
          log_level: :info
        }
      end

      def execute!(args = [], config = {})
        @args = args.dup
        @config = config
        @exec_config = default_config.merge!(config)

        trap_interrupt

        raise InvalidCommandError, "'#{command_arg}' is not a valid specimen command!" unless valid_command?

        show_gem_help_and_exit! if gem_help?
        show_command_help_and_exit! if command_help?
        binding.pry

        command_perform!

        exit_ok
      rescue StandardError => e
        shell.say(e.message.red.bold)

        if exec_config[:verbose]
          shell.say(e.class.to_s.red.bold)
          shell.say(e.backtrace&.join("\n").red)
        end

        exit_specimen_failed
      end

      def show_gem_help_and_exit!
        GemHelpCommand.new([]).perform

        exit_ok
      end

      def show_command_help_and_exit!
        display_command_help

        exit_ok
      end

      def display_command_help
        shallow_command.class_usage.nil? ? shallow_command.class.help(shell) : shell.say(shallow_command.class_usage)
      end

      def command_perform!
        command.new(command_arguments, parsed_command_options).perform
      end

      def shallow_command
        @shallow_command ||= command.new([])
      end

      def command_arg
        @command_arg ||= args.first
      end

      def command_arg?
        !command_arg.nil?
      end

      def command_arguments
        @command_arguments ||= args.reject { |arg| arg == command_arg }
      end

      def command
        @command ||= {
          cukes: CukesCommand,
          exec: ExecCommand,
          gem_help: GemHelpCommand,
          init: InitCommand,
          specs: SpecsCommand
        }[command_arg.to_sym]
      end

      def command_class_options
        command.class_options
      end

      def command_local_options
        @command_local_options ||= {}
      end

      # need to look into that
      def command_options_relation
        {exclusive_option_names: [], at_least_one_option_names: []}
      end

      def disable_required_check?
        return true if command_help?

        command.disable_required_check? command
      end

      def stop_on_unknown_option?
        exec_config[:strict] || false
      end

      def parsed_command_options
        Thor::Options.new(
          command_class_options,
          command_local_options,
          stop_on_unknown_option?,
          disable_required_check?,
          command_options_relation
        ).parse(command_arguments)
      end

      def command?
        COMMAND_MAPPINGS.include?(command_arg)
      end

      def command_help?
        HELP_MAPPINGS.include?(command_arguments.first)
      end

      def gem_help?
        return true if command_arg.nil?

        HELP_MAPPINGS.include?(command_arg)
      end

      def valid_command?
        command? || gem_help?
      end

      private

      def shell
        @shell ||= Thor::Base.shell.new
      end

      def exit_ok
        Kernel.exit(0)
      end

      def exit_specimen_failed
        Kernel.exit(1)
      end

      def exit_unable_to_finish
        Kernel.exit(2)
      end

      def trap_interrupt
        Signal.trap('INT') do
          shell.say("\nExiting... Interrupt again to exit immediately.".red.bold)
          exit_unable_to_finish
        end
      end
    end
  end
end
