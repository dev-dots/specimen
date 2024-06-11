# frozen_string_literal: true

version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.name = 'specimen'
  s.version = version
  s.summary = 'Specimen'
  s.description = 'Create maintainable automated tests using Rails-like COC approach'
  s.authors = ['Marek Witkowski']
  s.email = 'info@marekwitkowski.de'
  s.homepage = 'https://github.com/dev-dots/specimen'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.0'
  s.required_rubygems_version = '>= 3.0.1'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/dev-dots/specimen/issues',
    'rubygems_mfa_required' => 'true'
  }

  s.add_dependency 'activesupport', '~> 7.1'
  s.add_dependency 'thor', '~> 1.3'

  s.add_development_dependency 'pry', '~> 0.14.2'
  s.add_development_dependency 'rake', '~> 13.2.1'
  s.add_development_dependency 'rubocop', '~> 1.64.1'

  s.files = Dir["*.md", "bin/*", "lib/**/*.rb", "VERSION", "lib/**/*.tt"]
  s.require_path = 'lib'
  s.executables = ['specimen']
end
