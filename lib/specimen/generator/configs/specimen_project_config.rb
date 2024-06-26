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

      VALID_UI_DRIVER_NAMES = %w[selenium selenium-webdriver watir].freeze

      def self.parse(options)
        new(options).config
      end

      def initialize(options)
        @options = options
      end

      def config
        @config ||= {
          project_name: project_name,
          root_path: "#{Config.init_wd_path.to_path}/#{project_name}",
          gems: project_gems,
          api_only: api_only?,
          cucumber: !skip_cucumber?,
          rspec: !skip_rspec?,
          watir: !skip_watir?
        }
      end

      def project_gems
        reject_cucumber_gems if skip_cucumber?
        reject_all_ui_driver_gems if api_only?
        reject_ui_driver_gem unless api_only?

        gems.sort
      end

      def reject_cucumber_gems
        gems.reject! { |gem| gem.eql?('cucumber') || gem.eql?('cuke_modeler') }
      end

      def reject_all_ui_driver_gems
        gems.reject! { |gem| gem.eql?('selenium-webdriver') || gem.eql?('watir') }
      end

      def reject_ui_driver_gem
        raise "Invalid UI driver '#{ui_driver}'" unless VALID_UI_DRIVER_NAMES.include?(ui_driver)

        reject_watir_gem
        reject_selenium_gem
      end

      def reject_watir_gem
        gems.reject! { |gem| gem.eql?('watir') } if skip_watir? && ui_driver == 'watir'
        gems.reject! { |gem| gem.eql?('watir') } if ui_driver == 'selenium' || ui_driver == 'selenium-webdriver'
      end

      def reject_selenium_gem
        gems.reject! { |gem| gem.eql?('selenium-webdriver') } if ui_driver == 'watir' && !skip_watir?
      end

      def ui_driver
        @options[:ui_driver]
      end

      def project_name
        @options[:name]
      end

      def gems
        @gems ||= GEM_LIST.dup
      end

      def api_only?
        @options[:api_only]
      end

      def skip_cucumber?
        @options[:skip_cucumber]
      end

      def skip_rspec?
        @options[:skip_rspec]
      end

      def skip_watir?
        @options[:skip_watir]
      end
    end
  end
end
