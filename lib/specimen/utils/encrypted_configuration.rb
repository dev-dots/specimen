# frozen_string_literal: true

require 'active_support/encrypted_configuration'
require 'specimen/utils/encrypted_config_path'

module Specimen
  module Utils
    class EncryptedConfiguration
      class ExistingConfigFilesError < StandardError; end
      class NoSuchConfigError < StandardError; end
      class MissingKeyFileError < StandardError; end
      class MissingKeyFileError < StandardError; end

      attr_accessor :name
      attr_reader :enc_path, :env_key, :config_path, :key_path

      def self.create(name:)
        new(name:).create_encrypted_config!
      end

      def self.update(name:)
        new(name:).update_encrypted_config!
      end

      def self.validate(name:)
        new(name:).validate_encrypted_config!
      end

      def self.decrypt(name:, env_key: 'MASTER_KEY')
        new(name:, env_key:).decrypt_config!
      end

      def initialize(name:, env_key: '')
        @name = name
        @enc_path = EncryptedConfigPath.new(name:)
        @config_path = @enc_path.full_enc_path
        @key_path = @enc_path.full_key_path
        @env_key = env_key
      end

      def decrypt_config!
        raise NoSuchConfigError, "No such file: '#{config_path.to_path}'" unless config_exist?
        raise "Missing decryption key for enc-config '#{enc_path.name}'" unless decryption_key?

        YAML.load(enc_yml_content).deep_symbolize_keys!
      end

      def validate_encrypted_config!
        run_enc_files_check!
        YAML.load(enc_yml_content)
        enc_path
      rescue StandardError => e
        e
      end

      def enc_yml_content
        enc_config.read
      end

      def decryption_key?
        key_exist? || env_key_set?
      end

      def env_key_set?
        return false if env_key.empty?

        ENV.key?(env_key)
      end

      def run_enc_files_check!
        raise NoSuchConfigError, "No such file: '#{config_path.to_path}'" unless config_exist?
        raise MissingKeyFileError, "Missing encryption key file: '#{key_path.to_path}'" unless key_exist?
      end

      def update_encrypted_config!
        raise NoSuchConfigError, "No such file: '#{config_path.to_path}'" unless config_exist?
        raise MissingKeyFileError, "Missing encryption key file: '#{key_path.to_path}'" unless key_exist?
        raise 'Missing EDITOR variable' unless editor_set?
        raise "Can not find executable for editor '#{editor}'" unless editor?

        enc_config.change do |tmp_path|
          system("#{ENV.fetch('EDITOR')} #{tmp_path}")
        end
      end

      def create_encrypted_config!
        raise ExistingConfigFilesError, "Existing config at #{config_path.to_path}" if config_exist?
        raise ExistingConfigFilesError, "Existing key file at #{key_path.to_path}" if key_exist?

        create_key_file!
        create_enc_config!

        enc_path
      end

      def enc_config
        @enc_config ||= ActiveSupport::EncryptedConfiguration.new(
          config_path:,
          key_path:,
          env_key:,
          raise_if_missing_key: true
        )
      end

      def config_exist?
        enc_path.config_exist?
      end

      def key_exist?
        enc_path.key_exist?
      end

      def create_key_file!
        FileUtils.mkdir_p(key_path.dirname) unless key_path.directory?
        key_path.write(generate_key)
      end

      def create_enc_config!
        enc_config.write(example_yml)
      end

      def generate_key
        ActiveSupport::EncryptedFile.generate_key
      end

      def editor
        ENV.fetch('EDITOR')
      end

      def editor_set?
        ENV.fetch('EDITOR', false)
      end

      def editor?
        system("command -v #{editor}")
      end

      def example_yml
        <<~YML
          user:
            email: john.doe@example.com
            password: johnspassword

          service:
            host: https://api.my-website.biz
            client_id: secret-id
            client_secret: client-secret

          platform:
            website_url: https://my-website.biz
            admin_url: https://admin.my-website.biz
        YML
      end
    end
  end
end
