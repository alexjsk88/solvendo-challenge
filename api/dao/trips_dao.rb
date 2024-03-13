# frozen_string_literal: true

require './api/dao/purchases_dao'

module DAO
  # DAO Class to manage Trips
  class TripsDAO
    include Singleton

    def add(params)
      date_accumulator = DateTime.now
      db['INSERT INTO trips(departure_date, state_id, created_at, updated_at) VALUES (?, ?, ?, ?)',
         params[:departure_date],
         0,
         date_accumulator += 0.00005,
         date_accumulator += 0.00005].insert

      last_modified_row_id
    end

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

    def last_modified_row_id
      db.fetch('SELECT id FROM trips ORDER BY updated_at DESC LIMIT 1').all.first
    end
  end
end
