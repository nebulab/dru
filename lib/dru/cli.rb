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

    stop_on_unknown_option! :attach, :runner, :up

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

    desc 'up', 'Build, (re)create, start, and attach to default container'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :detach, aliases: '-d', type: :boolean,
                           desc: 'Detached mode'
    def up(*)
      if options[:help]
        invoke :help, ['up']
      else
        require_relative 'commands/up'
        Dru::Commands::Up.new(options: options).execute
      end
    end

    desc 'run', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    def runner(*command)
      if options[:help]
        invoke :help, ['runner']
      else
        require_relative 'commands/runner'
        Dru::Commands::Runner.new(command: command, options: options).execute
      end
    end
    map %w(run) => :runner
  end
end
