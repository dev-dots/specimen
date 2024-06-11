# frozen_string_literal: true

module Specimen
  module Generator
    class FileByTemplate < Commands::BaseGroupCommand
      argument :template_file, type: :string
      argument :destination, type: :string
      argument :data, type: :hash, default: {}

      def self.source_root
        "#{File.dirname(__FILE__)}/templates"
      end

      def create
        template(template_file, destination, data)
      end
    end
  end
end
