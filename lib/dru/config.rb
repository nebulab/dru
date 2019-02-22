require 'singleton'
require 'yaml'
require 'forwardable'
require 'json'

module Dru
  class Config
    extend Forwardable
    include Singleton

    def_delegators :configs, :docker_projects_folder, :alias

    DEFAULT = {
      'docker_projects_folder' => "~/.dru",
      'alias' => {}
    }.freeze

    attr_reader :config_file_path

    def config_file_path=(config_file_path)
      @configs = nil
      @config_file_path = config_file_path
    end

    private

    def configs
      @configs ||= JSON.parse(DEFAULT.merge(user_configs).to_json, object_class: OpenStruct)
    end

    def user_configs
      return {} unless config_file_path && File.file?(config_file_path)

      YAML.load_file(config_file_path) || {}
    end
  end
end
