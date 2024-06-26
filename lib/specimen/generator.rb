# frozen_string_literal: true

require_relative 'generator/generator_base'
require_relative 'generator/project_generator_base'
require_relative 'generator/file_by_template'

require_relative 'generator/configs/specimen_project_config'
require_relative 'generator/cucumber/cucumber_project_generator'
require_relative 'generator/project/project_root_generator'
require_relative 'generator/project/specimen_project_generator'
require_relative 'generator/rspec/rspec_project_generator'

module Specimen
  module Generator
    def create_file_by_template(template, destination, data = {})
      FileByTemplate.start([template, destination, data])
    end
  end
end
