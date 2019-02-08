require "dru/argv"
require "dru/config"
require "dru/cli"

module Dru
  DRUCONFIG = File.expand_path('~/.druconfig')
  DOCKER_COMMAND = 'docker'.freeze
  DOCKER_COMPOSE_COMMAND = 'docker-compose'.freeze
  DOCKER_COMPOSE_COMMANDS = %w[build bundle config create events exec images kill
                               logs pause port ps pull push restart rm scale
                               start stop top unpause down]

  def self.config
    Config.instance.tap { |instance| instance.config_file_path = DRUCONFIG }
  end
end
