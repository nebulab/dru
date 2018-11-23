# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Runner < Dru::Command
      def initialize(command, options)
        @command = command
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        system("docker-compose", *path, "run", "--rm", "--entrypoint", 'sh -c', @options[:container], @command.join(' '))
      end
    end
  end
end
