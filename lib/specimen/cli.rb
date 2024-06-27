# frozen_string_literal: true

require 'specimen'

config = {
  verbose: ENV.key?('VERBOSE'),
  strict: ENV.key?('STRICT'),
  log_level: ENV.key?('LOG_LEVEL') ? ENV.fetch('LOG_LEVEL').to_sym : :info
}

Specimen::Command.execute!(ARGV.dup, config)
