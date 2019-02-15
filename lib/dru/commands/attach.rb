# frozen_string_literal: true

require_relative '../command'

module Dru
  module Commands
    class Attach < Dru::Command
      ATTACH_COMMAND = 'attach'

      def initialize(service:, options:)
        @service = service
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        run_docker_command(ATTACH_COMMAND, detach_keys, container_id)
      end

      private

      def detach_keys
        "--detach-keys=#{@options[:detach_keys]}"
      end

      def container_id
        container_name_to_id(@service)
      end
    end
  end
end
