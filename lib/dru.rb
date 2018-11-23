require "dru/version"
require "dru/dru"
require "dru/config"

module Dru
  DRUCONFIG = File.expand_path('~/.druconfig') 

  def self.config
    Config.instance.tap { |instance| instance.config_file_path = DRUCONFIG }
  end
end
