# frozen_string_literal: true

require './api/models/truck'

module DAO
  # DAO Class to manage Templates
  class TrucksDAO
    include Singleton

    def add(params)
      ds = db['INSERT INTO trucks(plate_number, max_weight_capacity, work_days) VALUES(?, ?, ?)', params[:plate_number], 
                                                                                                  params[:max_weight_capacity], params[:work_days]]
      ds.insert
    end

    def remove(plate_number)
      p plate_number
      truck_trip_state = db.fetch('SELECT states.state FROM trucks
                                                       JOIN trips ON trucks.id = trips.truck_id
                                                       JOIN states ON trips.state_id = states.id
                                                       WHERE trucks.plate_number = ?', plate_number).all.first[:state]

      throw RuntimeError, 'Truck is not available' if truck_trip_state == 'On Trip'

      ds = db['DELETE FROM trucks WHERE plate_number = ?', plate_number]
      ds.delete
    end

    private

    def db
      Services[:database]
    end
  end
end
