# frozen_string_literal: true

module Specimen
  module Command
    class SpecsRunner < PathRunner
      no_commands do
        def perform
          super
          check_config_not_nil!
          inside runtime.work_dir do
            run(exec_cmd)
          end
        end

        def framework
          profile_config['framework'] || 'rspec'
        end

        def profile_name
          profile? ? profile : 'rspec'
        end
      end
    end
  end
end
