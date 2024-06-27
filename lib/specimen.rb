# frozen_string_literal: true

require 'active_support'
require 'colorize'

# require Ruby extensions
require 'specimen/extensions/ruby/hash'

require 'specimen/command'
require 'specimen/runtime'
require 'specimen/version'

module Specimen
  extend ActiveSupport::Autoload

  class << self
    attr_accessor :runtime
  end
end
