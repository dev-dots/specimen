# frozen_string_literal: true

require 'thor'

class Specimen < Thor
  GEM_NAME = 'specimen'
  GEM_VERSION = File.read('VERSION')

  desc 'build', 'build Specimen gem'

  def build
    system("gem build #{GEM_NAME}.gemspec")
  end

  desc 'install', 'install Specimen gem'

  def install
    system("gem install ./#{GEM_NAME}-#{GEM_VERSION}.gem")
  end

  desc 'clean', 'remove Specimen gem'

  def clean
    system('rm *.gem')
  end
end
