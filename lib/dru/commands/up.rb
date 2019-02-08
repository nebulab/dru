# frozen_string_literal: true

require_relative '../command'
require_relative './attach'

module Dru
  module Commands
    class Up < Dru::Command
      def initialize(options:)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        start_docker_compose
        return if options[:detach]

        attach_to_default_container
      end

      private

      def start_docker_compose
        run_docker_compose_command('up', '-d')
      end

      def attach_to_default_container
        Attach.new(service: 'app', options: { detach_keys: 'ctrl-d' }).execute
      end
    end
  end
end
