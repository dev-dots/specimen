# frozen_string_literal: true

require 'dotenv'
require 'specimen/config_parser'

module Specimen
  class Runtime
    class ConfigNotFoundError < RuntimeError; end
    class ProfileNotFoundError < RuntimeError; end

    attr_reader :wd_path, :config_directory,
                :program_name, :config_data,
                :profile_data, :framework

    attr_accessor :command, :specimen_config, :specimen_profile

    def initialize
      @wd_path = Pathname.getwd
      @config_directory = Pathname.new("#{wd_path}/config")
      @program_name = $PROGRAM_NAME
      @command = nil
      @specimen_config = nil
      @specimen_profile = nil
      @config_data = nil
      @profile_data = nil
    end

    def set_testrunner!(config, profile, command)
      @specimen_config = config
      @specimen_profile = profile
      @command = command

      define_framework!
      run_default_profile_checks!

      load_specimen_config!
      load_specimen_profile!
    end

    def run_load_profile_hook!
      @specimen_config = ENV.fetch('SPECIMEN_CONFIG_NAME')
      @specimen_profile = ENV.fetch('SPECIMEN_PROFILE_NAME')

      load_specimen_config!
      load_specimen_profile!
    end

    def run_env_file_hook!
      return unless profile_with_env_file?

      file = profile_data['env_file']
      path = Pathname.new("#{wd_path}/#{file}")

      return Dotenv.load!(path.to_path) if path.exist?

      raise "Environment file: '#{path.to_path}' is defined in profile '#{specimen_profile}' but it does not exist!"
    end

    def run_decrypt_enc_configs_hook!
      return unless profile_with_enc_configs?

      encrypted_config = {}
      enc_configs = profile_data['enc_configs']

      enc_configs.each do |enc_config|
        name = enc_config['name']
        env_key = enc_config['env_key']

        warn "env key '#{env_key}' defined but not set!" if env_key && !ENV.key?(env_key)
        env_key.nil? ? env_key = '' : env_key

        config = Specimen::Utils::EncryptedConfiguration.decrypt(name:, config_dir: '', env_key:)
        encrypted_config.merge!(config)
      end

      Specimen.enc_config = encrypted_config
    end

    def define_framework!
      raise 'Unrecognized command' unless cukes? || specs?

      @framework = cukes? ? 'cucumber' : 'rspec'
    end

    def run_default_profile_checks!
      raise 'You can not use the rspec profile with Cucumber!' if cukes? && specimen_profile == 'rspec'
      raise 'You can not use the cucumber profile with RSpec!' if specs? && specimen_profile == 'cucumber'
    end

    def load_specimen_profile!
      raise 'Specimen profile is not set!' if specimen_profile.nil? || specimen_profile.empty?

      unless config_data&.key?(specimen_profile)
        raise ProfileNotFoundError, "Can not find profile '#{specimen_profile}' in #{specimen_config_path.to_path}"
      end

      @profile_data = config_data[specimen_profile]
    end

    def load_specimen_config!
      raise ConfigNotFoundError, 'Specimen config not found' unless specimen_config_exist?

      @config_data = ConfigParser.read!(specimen_config_path.to_path)
    end

    def specimen_config_path
      Pathname.new("#{config_directory}/#{specimen_config}")
    end

    def custom_config
      @specimen_config
    end

    def profile_with_enc_configs?
      return false unless profile_data.is_a?(Hash)

      profile_data&.key?('enc_configs')
    end

    def profile_with_env_file?
      return false unless profile_data.is_a?(Hash)

      profile_data&.key?('env_file')
    end

    def cukes?
      return false if command.nil?

      command.is_a?(Command::CukesCommand)
    end

    def specs?
      return false if command.nil?

      command.is_a?(Command::SpecsCommand)
    end

    def specimen_config_exist?
      specimen_config_path.exist?
    end

    def specimen_bin?
      program_name.include?('bin/specimen')
    end

    def cucumber_bin?
      program_name.include?('bin/cucumber')
    end

    def parallel_cucumber_bin?
      program_name.include?('bin/parallel_cucumber')
    end
  end
end
