# frozen_string_literal: true

require_relative './command'

module Dru
  class ContainerCommand < Command
    def initialize(command, options)
      raise MissingContainerError unless options[:container]

      @options = options
      @command = command || []
    end

    def execute(input: $stdin, output: $stdout)
      raise NotImplementedError
    end

    protected

    def container
      options[:container]
    end
  end
end
