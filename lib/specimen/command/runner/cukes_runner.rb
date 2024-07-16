# frozen_string_literal: true

module Specimen
  module Command
    class CukesRunner < PathRunner
      class_option :specimen_config, aliases: %w[--sc], type: :string, default: 'specimen.cukes.yml'
      class_option :specimen_profile, aliases: %w[--sp], type: :string, default: 'cucumber'
    end
  end
end
