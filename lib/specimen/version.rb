# frozen_string_literal: true

module Specimen
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    PRE   = 'alpha.b'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
