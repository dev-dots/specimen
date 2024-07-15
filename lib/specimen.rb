# frozen_string_literal: true

require 'active_support'
require 'colorize'
require 'pathname'
require 'psych'

# require Ruby extensions
require 'specimen/extensions/ruby/hash'

require 'specimen/command'
require 'specimen/runtime'
require 'specimen/version'

module Specimen
  class << self
    attr_accessor :enc_config

    def runtime
      @runtime ||= Specimen::Runtime.new
    end

    def run_testrunner_hooks!
      runtime.run_load_profile_hook!
      runtime.run_env_file_hook!
      runtime.run_decrypt_enc_configs_hook!
    end
  end
end
