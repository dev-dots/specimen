# frozen_string_literal: true

require 'thor'

module Specimen
  module Commands
    class BaseCommand < Thor
      include Thor::Actions

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{self.namespace} #{task.name}"
      end
    end

    class BaseGroupCommand < Thor::Group
      include Thor::Actions

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{self.namespace} #{task.name}"
      end
    end
  end
end
