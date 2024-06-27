# frozen_string_literal: true

module Specimen
  module Generator
    class SpecimenProjectConfig
      class InvalidUIDriverError < RuntimeError
        def initialize(driver)
          @msg = "Invalid UI driver name '#{driver}'. Set --ui-driver to\n * #{VALID_UI_DRIVER_NAMES.join("\n * ")}"
          super(@msg)
        end
      end

      GEM_LIST = %w[
        activesupport dotenv ffaker rest-client thor uuid
        cucumber cuke_modeler parallel_tests rspec
        selenium-webdriver watir
        debug pry rubocop
      ].freeze

      VALID_UI_DRIVER_NAMES = %w[selenium selenium-webdriver watir].freeze

      def self.parse(options)
        new(options).parse_options
      end

      def initialize(options)
        @options = options
      end

      def parse_options
        run_ui_driver_check!
        config
      end

      def config
        @config ||= {
          project_name: project_name,
          root_path: "#{Config.init_wd_path.to_path}/#{project_name}",
          gems: project_gems,
          skip_ui: skip_ui?,
          cucumber: !skip_cucumber?,
          rspec: !skip_rspec?,
          ui_driver: ui_driver
        }
      end

      def run_ui_driver_check!
        return if skip_ui?

        raise InvalidUIDriverError, ui_driver unless VALID_UI_DRIVER_NAMES.include?(ui_driver)
      end

      def project_gems
        reject_cucumber_gems if skip_cucumber?
        reject_all_ui_driver_gems if skip_ui?
        reject_ui_driver_gem

        gems.sort
      end

      def reject_cucumber_gems
        gems.reject! { |gem| gem.eql?('cucumber') || gem.eql?('cuke_modeler') }
      end

      def reject_all_ui_driver_gems
        gems.reject! { |gem| gem.eql?('selenium-webdriver') || gem.eql?('watir') }
      end

      def reject_ui_driver_gem
        reject_watir_gem
        reject_selenium_gem
      end

      def reject_watir_gem
        gems.reject! { |gem| gem.eql?('watir') } if selenium?
      end

      def reject_selenium_gem
        gems.reject! { |gem| gem.eql?('selenium-webdriver') } if watir?
      end

      def selenium?
        ui_driver == 'selenium' || ui_driver == 'selenium-webdriver'
      end

      def watir?
        ui_driver == 'watir'
      end

      def ui_driver?
        !@options[:ui_driver].empty?
      end

      def ui_driver
        return nil if skip_ui?
        return @options[:ui_driver] if ui_driver?

        'watir'
      end

      def project_name
        @options[:name]
      end

      def gems
        @gems ||= GEM_LIST.dup
      end

      def skip_ui?
        @options[:skip_ui]
      end

      def skip_cucumber?
        @options[:skip_cucumber]
      end

      def skip_rspec?
        @options[:skip_rspec]
      end
    end
  end
end
