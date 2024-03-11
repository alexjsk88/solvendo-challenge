# frozen_string_literal: true

require './api/models/trip'

module DAO
  # DAO Class to manage Templates
  class TripsDAO
    include Singleton

    def add(type, params); end

    def all
      db.fetch('SELECT * FROM trips').all
    end

    def search_truck_on_trips(truck_id)
      db.fetch('SELECT states.state FROM trucks
                                    JOIN trips ON trucks.id = trips.truck_id
                                    JOIN states ON trips.state_id = states.id
                                    WHERE trucks.id = ?', truck_id).all.first
    end

    private

    def db
      Services[:database]
    end
  end
end
