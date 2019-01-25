# frozen_string_literal: true

module Dru
  class Argv
    attr_reader :argv

    def initialize(argv = ARGV)
      @argv = argv
    end

    def parse
      return argv unless docker_compose_command_index

      argv.dup.insert(docker_compose_command_index, Thor::Options::OPTS_END)
    end

    private

    def docker_compose_command_index
      argv.index { |arg| docker_compose_command?(arg) }
    end

    def docker_compose_command?(arg)
      Dru::DOCKER_COMPOSE_COMMANDS.include?(arg)
    end
  end
end
