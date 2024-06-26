# frozen_string_literal: true

require 'specimen/generator'

module Specimen
  module Command
    class InitCommand < BaseGroup
      class RequiredOptionError < StandardError
        def initialize
          @msg = "Please provide required option '--name'!"
          super(@msg)
        end
      end

      class ProjectNameError < StandardError
        def initialize
          @msg = "Option '--name' can not be empty or equal 'name'!"
          super(@msg)
        end
      end

      namespace :init

      class_option :name, aliases: %w[-n], type: :string
      class_option :api_only, type: :boolean, default: false
      class_option :ui_driver, type: :string, default: 'watir'
      class_option :skip_cucumber, type: :boolean, default: false
      class_option :skip_rspec, type: :boolean, default: false
      class_option :skip_watir, type: :boolean, default: false

      no_commands do
        def perform
          run_options_checks!

          Generator::SpecimenProjectGenerator.new(args, options).perform
        end

        def run_options_checks!
          raise RequiredOptionError if options[:name].nil?
          raise RequiredOptionError if options[:name].empty?
          raise ProjectNameError if options[:name] == 'name'
        end
      end
    end
  end
end
