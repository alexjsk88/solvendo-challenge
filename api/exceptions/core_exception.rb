# frozen_string_literal: true


module Exceptions
  class CoreException < StandardError
    attr_reader :data

    def initialize(data)
      super
      @data = data
    end

    def code
      'UNHANDLED_EXCEPTION'
    end

    def status_code
      500
    end
  end
end
