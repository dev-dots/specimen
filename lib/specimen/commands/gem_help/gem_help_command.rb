# frozen_string_literal: true

require 'specimen/command/base'

module Specimen
  module Command
    class GemHelpCommand < Base
      def self.source_root
        File.dirname(__FILE__)
      end

      no_commands do
        def perform
          if class_usage
            say class_usage
          else
            help
          end
        end
      end
    end
  end
end
