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
        Dru::Commands::Up.new(options).execute
      end
    end

    desc 'runner', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def runner(*)
      if options[:help]
        invoke :help, ['runner']
      else
        require_relative 'commands/runner'
        Dru::Commands::Runner.new(options).execute
      end
    end
  end
end
