# frozen_string_literal: true

module Specimen
  module Command
    class PathRunner < TestRunner
      argument :path, type: :string, default: ''

      no_commands do
        def arg_is_command_option?
          return false if path.empty?

          path.start_with?('--', '-')
        end

        def tests_path
          return @tests_path if @tests_path
          return '' if arg_is_command_option?

          @tests_path = path
        end
      end
    end
  end
end
