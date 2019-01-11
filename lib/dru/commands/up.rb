# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Up < Dru::Command
      DOCKER_ATTACH_COMMAND = 'docker attach --detach-keys="ctrl-d"'.freeze

      def initialize(options:)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        start_docker_compose
        return if options[:detach]

        stop_docker_compose if attach_to_default_container
      end

      private

      def start_docker_compose
        run_docker_compose_command('up', '-d')
      end

      def stop_docker_compose
        run_docker_compose_command('down')
      end

      def attach_to_default_container(container_name = 'app')
        system "#{DOCKER_ATTACH_COMMAND} #{container_name_to_id(container_name)}"
      end
    end
  end
end
