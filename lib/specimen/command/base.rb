# frozen_string_literal: true

module Specimen
  module Command
    class Base < Thor
      include Thor::Actions

      class << self
        def exit_on_failure?
          false
        end
      end

      no_commands do
        def usage_path
          find_in_source_paths('USAGE')
        rescue Thor::Error
          ''
        end

        def usage_content
          return '' if usage_path.empty?

          File.read(usage_path)
        end

        def class_usage
          return nil if usage_content.empty?

          ERB.new(usage_content, trim_mode: '-').result(binding)
        end
      end
    end
  end
end
