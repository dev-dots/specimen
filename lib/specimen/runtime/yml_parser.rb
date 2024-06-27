# frozen_string_literal: true

require 'psych'

module Specimen
  module Runtime
    class YmlParser
      class YmlTypeError < StandardError; end
      class YmlERBError < StandardError; end
      class YmlDataError < StandardError; end

      def self.parse!(file)
        new(file).parse
      end

      def initialize(file)
        @file = file
      end

      def parse
        specimen_yml_data
      end

      private

      def specimen_yml
        @specimen_yml ||= File.read(@file)
      end

      def specimen_yml_erb
        @specimen_yml_erb ||= ERB.new(specimen_yml, trim_mode: '%').result(binding)
      rescue StandardError
        raise YmlERBError, "#{@file} could not be parsed with ERB!"
      end

      def specimen_yml_data
        return @specimen_yml_data if @specimen_yml_data

        data = Psych.load(specimen_yml_erb, aliases: true)

        raise YmlTypeError, 'specimen.yml data could not be parsed' unless data.is_a?(Hash)

        @specimen_yml_data = data
      rescue StandardError
        raise YmlDataError, "Could not read data from: '#{@file}'!"
      end
    end
  end
end
