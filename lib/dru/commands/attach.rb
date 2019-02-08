# frozen_string_literal: true

require_relative '../container_command'

module Dru
  module Commands
    class Attach < Dru::ContainerCommand
      ATTACH_COMMAND = %w[attach --detach-keys=ctrl-d]

      def execute(input: $stdin, output: $stdout)
        attach_to_container
      end

      private

      def attach_to_container
        run_docker_command(*ATTACH_COMMAND, container_name_to_id(container))
      end
    end
  end
end
