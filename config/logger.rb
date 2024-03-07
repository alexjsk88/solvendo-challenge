# frozen_string_literal: true

# module for logs
module Logs
  class << self
    def info(message)
      Logger.new($stdout).info(message)
    end

    def error(message)
      Logger.new($stdout).error(message)
    end
  end
end
