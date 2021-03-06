# frozen_string_literal: true

require 'forwardable'

module Dru
  class Command
    extend Forwardable

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

    def override_docker_compose
      override = environment || 'override'
      docker_compose_file = File.join(project_configuration_path, "docker-compose.#{override}.yml")
      return unless File.exist?(docker_compose_file)
      docker_compose_file
    end

    def docker_compose_paths
      docker_compose_default_path + docker_compose_override_path
    end

    def run(*command, **options)
      command(options).run!(*command, { in: '/dev/tty', err: '/dev/tty' }.merge(options)).tap do |result|
        raise Dru::CLI::Error, result.err unless result.success?
      end
    end

    def run_docker_compose_command(*command, **options)
      run(DOCKER_COMPOSE_COMMAND, '-p', docker_compose_project_name, *docker_compose_paths, *command, **options)
    end

    def run_docker_command(*command, **options)
      run(DOCKER_COMMAND, *command, **options)
    end

    def container_name_to_id(container_name)
      run_docker_compose_command('ps', '-q', container_name, only_output_on_error: true).out.strip
    end

    def docker_compose_project_name
      return project_name unless environment

      "#{project_name}_#{environment}"
    end

    private

    def docker_compose_default_path
      ['-f', default_docker_compose]
    end

    def docker_compose_override_path
      return [] unless override_docker_compose

      ['-f', override_docker_compose]
    end
  end
end
