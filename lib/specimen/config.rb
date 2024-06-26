# frozen_string_literal: true

require 'specimen/config/runtime_config'
require 'specimen/config/path_config'
require 'specimen/config/specimen_settings'
require 'specimen/config/yml_parser'

module Specimen
  module Config
    def self.runtime_config
      @runtime_config ||= RuntimeConfig.new
    end

    def self.init_wd_path
      runtime_config.init_wd_path
    end

    def self.yml_data(file = '')
      return @yml_data if file.empty?

      @yml_data ||= YmlParser.parse!(file)
    end
  end
end
