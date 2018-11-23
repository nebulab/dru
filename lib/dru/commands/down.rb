# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Down < Dru::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        command.run('docker-compose', *path, 'down')
      end
    end
  end
end
