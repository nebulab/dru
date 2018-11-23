# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Attach < Dru::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        out, err = command(printer: :null).run("docker ps | grep _#{@options[:container]} | awk '{print $1}'")
        return_code = system "docker attach --detach-keys=\"ctrl-d\" #{out}"
        command.run('docker-compose -f ~/Code/docker-projects/floyd/docker-compose.yml down') if return_code
      end
    end
  end
end
