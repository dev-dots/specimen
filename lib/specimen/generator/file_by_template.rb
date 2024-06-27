# frozen_string_literal: true

module Specimen
  module Generator
    # Do not move this class to not screw up the template lookup path!
    class FileByTemplate < GeneratorBase
      argument :template_path, type: :string
      argument :destination, type: :string
      argument :data, type: :hash, default: {}

      def self.source_root
        File.dirname(__FILE__)
      end

      # Example template_path => 'project/templates/root/.gemrc'
      def create
        template(template_path, destination, data)
      end
    end
  end
end
