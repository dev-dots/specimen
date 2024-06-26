# frozen_string_literal: true

module Specimen
  module Command
    class SpecsCommand < CommonTestRunner
      argument :path, type: :string, default: ''

      namespace :specs

      def self.banner
        'specimen specs'
      end

      def self.desc
        'run RSpec tests'
      end

      no_commands do
        def framework
          'rspec'
        end
      end
    end
  end
end
