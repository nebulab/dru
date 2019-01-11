# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Exec < Dru::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
