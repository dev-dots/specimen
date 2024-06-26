# frozen_string_literal: true

module Specimen
  module Command
    class ExecCommand < CommonTestRunner
      namespace :exec

      argument :profile, default: ''

      no_commands do
        def perform
          binding.pry

        end
      end
    end
  end
end
