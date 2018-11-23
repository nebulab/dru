# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Exec < Dru::Command
      def initialize(command, options)
        @command = command
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # command.run("docker-compose", "-f", "/Users/chrimo/Code/docker-projects/floyd/docker-compose.yml", "exec", @options[:container], *@command)
        system('docker-compose', *path, 'exec', @options[:container], *@command)
      end
    end
  end
end
