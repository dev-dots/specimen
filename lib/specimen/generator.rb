# frozen_string_literal: true

require_relative 'generator/file_by_template'
require_relative 'generator/specimen_project'

module Specimen
  module Generator
    def create_file_by_template(template, destination, data = {})
      FileByTemplate.start([template, destination, data])
    end
  end
end
