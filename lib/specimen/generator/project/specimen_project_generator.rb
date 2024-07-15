# frozen_string_literal: true

module Specimen
  module Generator
    class SpecimenProjectGenerator < GeneratorBase
      def execute!
        perform
      end

      no_commands do
        def perform
          ProjectRootGenerator.start([config])
          CucumberProjectGenerator.start([config]) if config[:cucumber]
          RSpecProjectGenerator.start([config]) if config[:rspec]

          inside config[:root_path] do
            run('specimen enc create --name example')

            env_file = '.example.env'
            enc_key = File.read "#{Dir.pwd}/config/enc/example.key"
            content = "MASTER_KEY='#{enc_key}'\n"
            File.write(env_file, content)

            say("Created env-file '#{env_file}' containing the MASTER_KEY to decrypt config/enc/example.yml.enc".bold)
          end

          say(init_message.green.bold)
          true
        end

        def config
          @config ||= Generator::SpecimenProjectConfig.parse(options)
        end

        def init_message
          enc_config = 'config/enc/example.yml.enc'

          <<~STRING

            Created new specimen project in 
            #{config[:root_path]}

            Please cd into the directory and run e.g.

            # check out the help for cukes and specs command 
            $> specimen cukes|specs --help|-h 

            # run tests using the encrypted example configuration
            $> specimen cukes|specs --specimen-profile|--sp examples

            # Check out the 'enc' command help
            $> specimen enc --help|-h

            # Read and update the encrypted config '#{enc_config}'
            $> specimen enc update --name|-n example

          STRING
        end
      end
    end
  end
end
