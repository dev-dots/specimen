# frozen_string_literal: true

module Specimen
  module Command
    class SpecsRunner < PathRunner
      class_option :specimen_config, aliases: %w[--sc], type: :string, default: 'specimen.specs.yml'
      class_option :specimen_profile, aliases: %w[--sp], type: :string, default: 'rspec'
    end
  end
end
