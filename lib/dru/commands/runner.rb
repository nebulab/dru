# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Runner < Dru::Command
      def initialize(command, options)
        raise MissingContainerError unless options[:container]

        @options = options
        @command = command || []
      end

      def execute(input: $stdin, output: $stdout)
        run_docker_compose_command('run', '--rm', '--entrypoint', 'sh -c', container, command, tty: true)
      end

      private

      def command
        @command.join(' ')
      end

      def container
        options[:container]
      end
    end
  end
end
