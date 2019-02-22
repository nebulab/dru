# frozen_string_literal: true

require 'shellwords'

module Dru
  class Argv
    attr_reader :argv

    def self.parse(*args)
      new(*args).parse
    end

    def initialize(argv = ARGV)
      @argv = argv.dup
    end

    def parse
      return argv unless known_command

      if dru_command?(known_command)
        parse_dru_command
      elsif docker_compose_command?(known_command)
        parse_docker_compose_command
      else
        parse_alias_command
      end
    end

    private

    def parse_docker_compose_command
      argv.insert(known_command_index, Thor::Options::OPTS_END)
    end

    def parse_dru_command
      argv.unshift(argv.delete(known_command))
    end

    def parse_alias_command
      argv[known_command_index] = Shellwords.split(Dru.config.alias[known_command])
      @argv = self.class.parse(argv.flatten)
    end

    def known_command
      argv[known_command_index] if known_command_index
    end

    def known_command_index
      @known_command_index ||= argv.index do |arg|
        dru_command?(arg) || docker_compose_command?(arg) || alias_command?(arg)
      end
    end

    def docker_compose_command?(command)
      Dru::DOCKER_COMPOSE_COMMANDS.include?(command)
    end

    def dru_command?(command)
      Dru::CLI.commands.keys.push('help').include?(command)
    end

    def alias_command?(command)
      Dru.config.alias.respond_to?(command)
    end
  end
end
