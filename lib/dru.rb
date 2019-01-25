require "dru/config"
require "dru/cli"

module Dru
  DRUCONFIG = File.expand_path('~/.druconfig') 
  DOCKER_COMPOSE_COMMAND = 'docker-compose'.freeze

  def self.config
    Config.instance.tap { |instance| instance.config_file_path = DRUCONFIG }
  end
end
