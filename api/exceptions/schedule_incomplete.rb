# frozen_string_literal: true

require_relative 'core_exception'

module Exceptions
  # Class to manage TruckNotFound
  class ScheduleIncomplete < CoreException
    def code
      'SCHEDULE_INCOMPLETE'
    end

    def status_code
      422
    end
  end
end
