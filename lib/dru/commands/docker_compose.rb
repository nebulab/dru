# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class DockerCompose < Dru::Command
      attr_reader :command

      def initialize(options:, command:)
        @options = options
        @command = command
      end

      def execute(input: $stdin, output: $stdout)
        run_docker_compose_command(*command, tty: true)
      end
    end
  end
end
