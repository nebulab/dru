require "dru/argv"
require "dru/config"
require "dru/cli"

module Dru
  DOCKER_COMMAND = 'docker'.freeze
  DOCKER_COMPOSE_COMMAND = 'docker-compose'.freeze
  DOCKER_COMPOSE_COMMANDS = %w[build bundle config create events exec images kill
                               logs pause port ps pull push restart rm run scale
                               start stop top unpause down]

  def self.config
    @config ||= Dru::Config.new
  end
end
