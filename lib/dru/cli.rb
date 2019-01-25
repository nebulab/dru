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

    desc 'version', 'dru version'
    def version
      require_relative 'version'
      puts "v#{Dru::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'docker_compose', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def docker_compose(*)
      if options[:help]
        invoke :help, ['docker_compose']
      else
        require_relative 'commands/docker_compose'
        Dru::Commands::DockerCompose.new(options).execute
      end
    end

    desc 'down', 'Stops containers and removes containers, networks, volumes, and images created by `up`.'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def down(*)
      if options[:help]
        invoke :help, ['down']
      else
        require_relative 'commands/down'
        Dru::Commands::Down.new.execute
      end
    end

    desc 'attach', 'Attach local standard input, output, and error streams to a running container'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    def attach(*)
      if options[:help]
        invoke :help, ['attach']
      else
        require_relative 'commands/attach'
        Dru::Commands::Attach.new(options: options).execute
      end
    end

    desc 'exec', 'Execute a command in a running container.'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    def exec(*command)
      if options[:help]
        invoke :help, ['exec']
      else
        require_relative 'commands/exec'
        Dru::Commands::Exec.new(command: command, options: options).execute
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
