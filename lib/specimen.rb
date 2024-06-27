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
  extend ActiveSupport::Autoload

  class << self
    attr_accessor :runtime

    def init_wd_path
      @init_wd_path ||= Pathname.getwd
    end
  end
end
