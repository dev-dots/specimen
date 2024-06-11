# frozen_string_literal: true

require 'active_support'

# require Ruby extensions
require 'specimen/extensions/ruby/hash'

require 'specimen/version'

module Specimen
  extend ActiveSupport::Autoload

  autoload :CLI
  autoload :Commands
  autoload :Generator
end
