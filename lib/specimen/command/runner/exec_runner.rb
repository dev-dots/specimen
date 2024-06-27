# frozen_string_literal: true

module Specimen
  module Command
    class ExecRunner < TestRunner
      class_option :profile, aliases: %w[-p], type: :string

      no_commands do
        def perform
          super

          run_profile_check!
          check_config_not_nil!
          inside runtime.work_dir do
            run(exec_cmd)
          end
        end

        def tests_path
          ''
        end

        def run_profile_check!
          raise "Missing command option '--profile|-p'" unless profile?
        end

        def framework
          profile_config['framework'] || nil
        end

        def profile_name
          profile? ? profile : nil
        end
      end
    end
  end
end
