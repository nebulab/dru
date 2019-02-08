# frozen_string_literal: true

require_relative '../container_command'

module Dru
  module Commands
    class Runner < Dru::ContainerCommand
      def execute(input: $stdin, output: $stdout)
        run_docker_compose_command('run', '--rm', '--entrypoint', 'sh -c', container, commands, tty: true)
      end

      private

      def commands
        @command.join(' ')
      end
    end
  end
end
