# frozen_string_literal: true

module Specimen
  class ConfigParser
    class YmlERBError < StandardError; end

    def self.read!(file)
      new(file).yml_load!
    end

    def initialize(file)
      @file = file
    end

    def yml_load!
      YAML.safe_load(erb_content, aliases: true)
    end

    private

    def content
      File.read(@file)
    end

    def erb_content
      ERB.new(content, trim_mode: '%').result(binding)
    rescue StandardError
      raise YmlERBError, "#{@file} could not be parsed with ERB!"
    end
  end
end
