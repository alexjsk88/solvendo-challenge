# frozen_string_literal: true

require_relative 'core_exception'

module Exceptions
  # Class to manage TruckNotFound
  class TruckNotFound < CoreException
    def code
      'TRUCK_NOT_FOUND'
    end

    def status_code
      422
    end
  end
end
