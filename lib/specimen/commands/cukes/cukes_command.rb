# frozen_string_literal: true

module Specimen
  module Command
    class CukesCommand < CommonTestRunner
      argument :path, type: :string, default: ''

      namespace :cukes

      def self.banner
        'specimen cukes'
      end

      def self.desc
        'run Cucumber tests'
      end

      no_commands do
        def framework
          'cucumber'
        end
      end
    end
  end
end
