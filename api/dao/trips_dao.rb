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
         date_accumulator + 0.00005].insert

      last_modified_row_id
    end

    def all
      db.fetch('SELECT * FROM trips').all
    end

    def all_in_pending_state
      db.fetch('SELECT t.id as trip_id, t.departure_date FROM trips as t
                WHERE t.state_id = 0').all
    end

    def all_with_trucks
      db.fetch('SELECT trips.id as trip_id, trucks.plate_number as plate_number
                FROM trips
                JOIN trucks ON trips.truck_id = trucks.id
                WHERE trips.truck_id IS NOT NULL').all
    end

    def total_weight_based_on_purschases(trip_id)
      db.fetch('SELECT SUM(weight) AS total_weight
                FROM trips
                JOIN purchases ON trips.id = purchases.trip_id
                WHERE trip_id = ?
                GROUP BY trip_id', trip_id).all.first[:total_weight]
    end

    def search_truck_on_trips(truck_id)
      db.fetch('SELECT states.state FROM trucks
                                    JOIN trips ON trucks.id = trips.truck_id
                                    JOIN states ON trips.state_id = states.id
                                    WHERE trucks.id = ?', truck_id).all.first
    end

    def update_truck_id_by_trip_id(truck_id, trip_id)
      db['UPDATE trips SET truck_id = ? WHERE id = ?', truck_id, trip_id].update
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
