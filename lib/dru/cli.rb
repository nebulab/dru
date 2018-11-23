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

    desc 'version', 'dru version'
    def version
      require_relative 'version'
      puts "v#{Dru::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'run', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    method_option :environment, aliases: '-e', type: :string, default: 'development',
                                desc: 'Environment'
    def runner(*command)
      if options[:help]
        invoke :help, ['runner']
      else
        require_relative 'commands/runner'
        Dru::Commands::Runner.new(command, options).execute
      end
    end
    map %w(run) => :runner

    desc 'shell', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    method_option :environment, aliases: '-e', type: :string, default: 'development',
                                desc: 'Environment'
    def console(*)
      if options[:help]
        invoke :help, ['console']
      else
        runner('sh') # exec('sh')
      end
    end
    map %w(shell) => :console

    desc 'exec COMMAND', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    method_option :environment, aliases: '-e', type: :string, default: 'development',
                                desc: 'Environment'
    def exec(*command)
      if options[:help]
        invoke :help, ['exec']
      else
        require_relative 'commands/exec'
        Dru::Commands::Exec.new(command, options).execute
      end
    end

    desc 'attach', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :container, aliases: '-c', type: :string, default: 'app',
                              desc: 'Container name'
    def attach(*)
      if options[:help]
        invoke :help, ['attach']
      else
        require_relative 'commands/attach'
        Dru::Commands::Attach.new(options).execute
      end
    end

    desc 'down', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :environment, aliases: '-e', type: :string, default: 'development',
                                desc: 'Environment'
    def down(*)
      if options[:help]
        invoke :help, ['down']
      else
        require_relative 'commands/down'
        Dru::Commands::Down.new(options).execute
      end
    end

    desc 'up', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :detach, aliases: '-d', type: :boolean,
                           desc: 'Detached mode'
    def up(*)
      if options[:help]
        invoke :help, ['up']
      else
        require_relative 'commands/up'
        Dru::Commands::Up.new(options).execute
      end
    end
  end
end
