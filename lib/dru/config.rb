require 'tty-config'
require 'ostruct'

module Dru
  class Config
    attr_reader :config

    DRUCONFIG = '.druconfig'.freeze
    DOCKER_PROJECTS_FOLDER = "#{Dir.home}/.dru".freeze
    ALIAS = {}.freeze

    def initialize(druconfig: DRUCONFIG,
                   docker_projects_folder: DOCKER_PROJECTS_FOLDER)
      @config = TTY::Config.new
      @config.filename = druconfig
      @config.append_path Dir.home

      begin
        @config.read(format: :yaml) if @config.exist?
      rescue TypeError
        # Do nothing in case the file exists but is empty
      end

      @config.set_if_empty :docker_projects_folder, value: docker_projects_folder
      @config.set_if_empty :alias, value: ALIAS
    end

    def docker_projects_folder
      @config.fetch(:docker_projects_folder)
    end

    def alias
      OpenStruct.new(@config.fetch(:alias))
    end
  end
end
