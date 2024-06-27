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

      class_option :config_file, aliases: %w[-C --config], type: :string, default: 'specimen.yml'

      no_commands do
        def perform
          runtime
        end

        def runtime
          return @runtime if @runtime

          runtime = Runtime.start!(self)
          Specimen.runtime = runtime
          @runtime = runtime
        end

        def framework
          nil
        end

        def profile
          options[:profile]
        end

        def profile?
          !profile.nil?
        end

        def profile_config
          runtime.profile_yml_data(profile_name)
        end

        def profile_name
          profile? ? profile : nil
        end

        def exec_cmd
          ExecCommandBuilder.new(config: profile_config, framework:, tests_path:).build_cmd
        end

        def check_config_not_nil!
          raise ProfileDataNilError.new(profile_name, runtime.yml_name) if profile? && profile_config.nil?
        end
      end
    end
  end
end
