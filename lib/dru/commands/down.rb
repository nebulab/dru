# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Down < Dru::Command
      def execute(input: $stdin, output: $stdout)
        run_docker_compose_command('down')
      end
    end
  end
end
