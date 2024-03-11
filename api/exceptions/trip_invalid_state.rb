# frozen_string_literal: true

require_relative 'core_exception'

module Exceptions
  # Class to manage TripInvalidState
  class TripInvalidState < CoreException
    def code
      'TRIP_INVALID_STATE_TO_REMOVE_TRUCK'
    end

    def status_code
      422
    end
  end
end
