# frozen_string_literal: true

require_relative '../container_command'

module Dru
  module Commands
    class Exec < Dru::ContainerCommand
      def execute(input: $stdin, output: $stdout)
        run_docker_compose_command('exec', container, *@command, tty: true)
      end
    end
  end
end
