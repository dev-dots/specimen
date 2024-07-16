# frozen_string_literal: true

module Specimen
  module Utils
    class EncryptedConfigPath
      ENC_DIRECTORY = 'config/enc'

      attr_reader :name, :runtime

      def initialize(name:)
        @name = name
        @runtime = Specimen.runtime
      end

      def config_base_dir
        @config_base_dir ||= Pathname.new("#{runtime.wd_path}/#{ENC_DIRECTORY}")
      end

      def enc_dir
        return Pathname.new(config_base_dir.to_path) if config_dir.empty?

        Pathname.new("#{config_base_dir}/#{config_dir}")
      end

      def config_file_name
        "#{split_name.last}.yml.enc"
      end

      def config_dir
        split_name[0...-1].join('/')
      end

      def split_name
        name.split('/')
      end

      def full_enc_path
        @full_enc_path ||= Pathname.new("#{enc_dir}/#{config_file_name}")
      end

      def full_key_path
        @full_key_path ||= Pathname.new("#{enc_dir}/#{config_file_name.gsub('.yml.enc', '.key')}")
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
