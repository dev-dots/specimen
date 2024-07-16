# frozen_string_literal: true

require 'specimen/utils'

module Specimen
  module Command
    class EncryptedConfigurationCommand < Base
      class RequiredOptionError < StandardError
        def initialize
          @msg = "Please provide required option '--name'!"
          super(@msg)
        end
      end

      class OptionNameError < StandardError
        def initialize
          @msg = "Option '--name' can not be empty or equal 'name'!"
          super(@msg)
        end
      end

      class ExistingConfigFilesError < StandardError; end
      class NoSuchConfigError < StandardError; end
      class MissingKeyFileError < StandardError; end

      include Utils

      def self.source_root
        File.dirname(__FILE__)
      end

      class_option :name, aliases: %w[-n], type: :string
      class_option :editor, aliases: %w[-e], type: :string, default: 'vi'

      desc 'create', 'create'

      def create
        encrypted_config = EncryptedConfiguration.create(name:)

        say(gen_message(encrypted_config).green.bold)
        say("\n  NEVER COMMIT/PUBLISH '*.key' files to your repository !!!\n".bold)
      end

      desc 'update', 'update'

      def update
        ENV['EDITOR'] = ENV.fetch('EDITOR', options[:editor])
        EncryptedConfiguration.update(name:)

        say("Updated encrypted config '#{name}.yml.enc'".green)
      end

      desc 'validate', 'validate'

      def validate
        result = EncryptedConfiguration.validate(name:)

        say("Config '#{name}.yml.enc' validated and ready to use".green) if result.is_a?(EncryptedConfigPath)
        return if result.is_a?(EncryptedConfigPath)

        say("#{result.class}\n #{result.message}".red)
        say('Please fix the yml syntax errors before you proceed'.bold)
      end

      no_commands do
        def perform
          run_args_check!
          run_options_checks!

          send(task_arg)
        end

        def name
          options[:name]
        end

        def task_arg
          args.first
        end

        def task?
          respond_to?(task_arg)
        end

        def run_args_check!
          return if task?

          raise "No such command: '#{task_arg}'. Either use 'specimen enc create' or 'specimen enc update'"
        end

        def run_options_checks!
          raise RequiredOptionError if options[:name].nil?
          raise RequiredOptionError if options[:name].empty?
          raise OptionNameError if options[:name] == 'name'
        end

        def gen_message(enc_path)
          <<~STRING
            Generated new encrypted configuration: '#{enc_path.name}.yml.enc'

              encrypted-config-path: #{enc_path.full_enc_path.to_path}
              encryption-key-path: #{enc_path.full_key_path.to_path}
          STRING
        end
      end
    end
  end
end
