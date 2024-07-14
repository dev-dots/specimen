# frozen_string_literal: true

module Specimen
  module Utils
    class EncryptedConfigPath
      ENC_DIRECTORY = 'config/enc'

      attr_reader :name, :config_dir

      def initialize(name:, config_dir: '')
        @name = name
        @config_dir = config_dir
      end

      def yml_file_name
        "#{name}.yml.enc"
      end

      def key_file_name
        "#{name}.key"
      end

      def config_base_dir
        @config_base_dir ||= Pathname.new("#{Specimen.init_wd_path}/#{ENC_DIRECTORY}")
      end

      def enc_dir
        return @enc_dir if @enc_dir
        return @enc_dir = config_base_dir if config_dir.empty?

        @enc_dir = Pathname.new("#{config_base_dir}/#{config_dir}")
      end

      def full_enc_path
        @full_enc_path ||= Pathname.new("#{enc_dir}/#{yml_file_name}")
      end

      def full_key_path
        @full_key_path ||= Pathname.new("#{enc_dir}/#{key_file_name}")
      end

      def config_exist?
        full_enc_path.exist?
      end

      def key_exist?
        full_key_path.exist?
      end
    end
  end
end
