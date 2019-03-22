# frozen_string_literal: true

require 'thor'

module Dru
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    class_option :environment, aliases: '-e', type: :string,
                                desc: 'Environment'

    default_command :docker_compose

    stop_on_unknown_option! :attach, :up

    def self.help(shell, subcommand = false)
      shell.say `#{DOCKER_COMPOSE_COMMAND} help`
      shell.say

      shell.say <<-OUT
These Docker-Compose commands are provided by Dru:

Usage:
  dru [-e ENV] [docker-compose-options] [COMMAND] [ARGS...]
  dru -h|--help

      OUT

      super
    end

    desc 'version', 'dru version'
    def version
      require_relative 'version'
      shell.say "dru version: #{Dru::VERSION}"
      shell.say `#{DOCKER_COMPOSE_COMMAND} version`
    end
    map %w(--version -v) => :version

    desc 'docker-compose', 'Run docker-compose', hide: true
    def docker_compose(*command)
      if command.empty?
        invoke :help
      else
        require_relative 'commands/docker_compose'
        Dru::Commands::DockerCompose.new(command: command, options: options).execute
      end
    end

    desc 'attach [OPTIONS] SERVICE', 'Attach local standard input, output, and error streams to a running service'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :detach_keys, type: :string, default: 'ctrl-d',
                         desc: 'Override the key sequence for detaching a container'
    def attach(service = nil)
      if options[:help] || service.nil?
        invoke :help, ['attach']
      else
        require_relative 'commands/attach'
        Dru::Commands::Attach.new(service: service, options: options).execute
      end
    end
  end
end
