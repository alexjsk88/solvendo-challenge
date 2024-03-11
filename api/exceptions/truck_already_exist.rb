# frozen_string_literal: true

require_relative 'core_exception'

module Exceptions
  # Class to manage TruckAlreadyExist
  class TruckAlreadyExist < CoreException
    def code
      'TRUCK_ALREADY_EXIST'
    end

    def status_code
      422
    end
  end
end
