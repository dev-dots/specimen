# frozen_string_literal: true

module Specimen
  module Command
    class TestRunner < BaseGroup
      class ProfileDataNilError < RuntimeError
        def initialize(profile_name, yml_name)
          @msg = "No data found in '#{yml_name}' for profile: '#{profile_name}'"
          super(@msg)
        end
      end

      class_option :tags, aliases: ['-t'], type: :string, repeatable: true, default: []
      class_option :debug, type: :boolean, default: false
      class_option :verbose, type: :boolean, default: false

      no_commands do
        def perform
          runtime.set_testrunner!(specimen_config, specimen_profile, self)

          inside runtime.wd_path do
            ENV['SPECIMEN_CONFIG_NAME'] = runtime.specimen_config
            ENV['SPECIMEN_PROFILE_NAME'] = runtime.specimen_profile

            ENV['DEBUG'] = 'true' if options[:debug]
            ENV['VERBOSE'] = 'true' if options[:verbose]

            @success = run(exec_cmd)
          end

          @success == true ? exit(0) : exit(1)
        end

        def runtime
          Specimen.runtime
        end

        def specimen_config
          options[:specimen_config]
        end

        def specimen_profile
          options[:specimen_profile]
        end

        def exec_cmd
          ExecCommandBuilder.build_exec_cmd!
        end
      end
    end
  end
end
