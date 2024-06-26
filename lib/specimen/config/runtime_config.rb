# frozen_string_literal: true

module Specimen
  module Config
    class RuntimeConfig
      attr_reader :init_wd_path

      def initialize
        @init_wd_path = Pathname.getwd
      end
    end
  end
end
