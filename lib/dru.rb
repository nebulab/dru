require "dru/config"
require "dru/cli"

module Dru
  DRUCONFIG = File.expand_path(ENV['DRUCONFIG'] || '~/.druconfig')

  def self.config
    Config.instance.tap { |instance| instance.config_file_path = DRUCONFIG }
  end
end
