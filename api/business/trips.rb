# frozen_string_literal: true

require './api/dao/trips_dao'
require './api/services/http_client'
require './api/utils/constants'

module Business
  # Handle business logic for trips
  class Trips
    include Singleton

    def trips
      p 'trips'
    end

    def schedule(scheduling_date)
      p 'trip schedule'
    end
  end
end
