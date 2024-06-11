# frozen_string_literal: true

module Specimen
  module Generator
    class SpecimenProjectConfig
      GEM_LIST = %w[
        activesupport dotenv ffaker rest-client thor uuid
        cucumber cuke_modeler parallel_tests rspec
        selenium-webdriver watir
        debug pry rubocop
      ].freeze

      def initialize(options)
        @options = options
      end

      def data
        @data ||= {
          project_name: project_name,
          gems: project_gems,
          project_root: project_root,
          api_only: api_only?,
          cucumber: cucumber?
        }
      end

      def project_gems
        gems.reject! { |gem| gem.eql?('selenium-webdriver') || gem.eql?('watir') } if api_only?
        gems.reject! { |gem| gem.eql?('cucumber') || gem.eql?('cuke_modeler') } unless cucumber?
        gems.sort
      end

      def project_root
        "#{@options[:destination_root]}/#{project_name}"
      end

      def project_name
        @options[:project_name]
      end

      def gems
        @gems ||= GEM_LIST.dup
      end

      def api_only?
        @options[:api_only]
      end

      def cucumber?
        @options[:cucumber]
      end
    end
  end
end
