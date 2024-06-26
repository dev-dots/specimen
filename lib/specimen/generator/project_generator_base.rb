# frozen_string_literal: true

module Specimen
  module Generator
    class ProjectGeneratorBase < GeneratorBase
      argument :config

      no_commands do
        def root_path
          @root_path ||= config[:root_path]
        end

        def create_directories(dirs, destination_path = root_path)
          empty_directory(destination_path)

          inside destination_path do
            dirs.each { |dir| empty_directory(dir) }
          end
        end

        def create_files_by_templates(templates_dir, templates = [], destination_path = root_path)
          template_paths = templates.map { |template| "#{templates_dir}/#{template}" }

          template_paths.each do |template|
            file_destination = template.gsub(templates_dir, '').delete_prefix('/')
            file_destination_path = "#{destination_path}/#{file_destination}"

            create_file_by_template(template, file_destination_path, config)
          end
        end
      end
    end
  end
end
