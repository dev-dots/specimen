# frozen_string_literal: true

require 'specimen'
require 'specimen/cli/default_command'

module Specimen
  module CLI
    class << self
      def start!(args = ARGV)
        command = args.shift

        case command
        when '--version', '-v'
          show_version
        else
          DefaultCommand.start(ARGV.dup)
        end
      end

      def show_version
        puts(Specimen::VERSION::STRING)
      end
    end
  end
end
