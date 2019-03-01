# frozen_string_literal: true

require 'forwardable'

module Dru
  class Command
    extend Forwardable

    class MissingContainerError < StandardError
      def initialize(msg = 'Missing container')
        super
      end
    end

    attr_accessor :options

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # @api public
    def command(**options)
      require 'tty-command'
      TTY::Command.new({ printer: :quiet, uuid: false }.merge(options))
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      require 'tty-editor'
      TTY::Editor
    end

    # File manipulation utility methods
    #
    # @see http://www.rubydoc.info/gems/tty-file
    #
    # @api public
    def generator
      require 'tty-file'
      TTY::File
    end

    # Terminal platform and OS properties
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def platform
      require 'tty-platform'
      TTY::Platform.new
    end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(options)
    end

    # The unix which utility
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def which(*args)
      require 'tty-which'
      TTY::Which.which(*args)
    end

    # Check if executable exists
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def exec_exist?(*args)
      require 'tty-which'
      TTY::Which.exist?(*args)
    end

    def project_name
      File.basename(Dir.pwd)
    end

    def environment
      options && options[:environment]
    end

    def project_configuration_path
      File.expand_path(project_name, Dru.config.docker_projects_folder)
    end

    def default_docker_compose
      File.join(project_configuration_path, 'docker-compose.yml')
    end

    def environment_docker_compose
      return unless environment

      File.join(project_configuration_path, "docker-compose.#{environment}.yml")
    end

    def docker_compose_paths
      docker_compose_default_path + docker_compose_environment_path
    end

    def run(*command, **options)
      command(options).run!(*command, { in: '/dev/tty', err: '/dev/tty' }.merge(options)).tap do |result|
        raise Dru::CLI::Error, result.err unless result.success?
      end
    end

    def run_docker_compose_command(*command, **options)
      run(DOCKER_COMPOSE_COMMAND, *docker_compose_paths, *command, **options)
    end

    def run_docker_command(*command, **options)
      run(DOCKER_COMMAND, *command, **options)
    end

    def container_name_to_id(container_name)
      run_docker_compose_command('ps', '-q', container_name, only_output_on_error: true).out.strip
    end

    private

    def docker_compose_default_path
      ['-f', default_docker_compose]
    end

    def docker_compose_environment_path
      return [] unless environment_docker_compose

      ['-f', environment_docker_compose]
    end
  end
end
