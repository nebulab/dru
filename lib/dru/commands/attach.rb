# frozen_string_literal: true

require_relative '../container_command'

module Dru
  module Commands
    class Attach < Dru::ContainerCommand
      DOCKER_ATTACH_COMMAND = 'docker attach --detach-keys="ctrl-d"'.freeze

      def execute(input: $stdin, output: $stdout)
        attach_to_container
      end

      private

      def attach_to_container
        system "#{DOCKER_ATTACH_COMMAND} #{container_name_to_id(container)}"
      end
    end
  end
end
