# frozen_string_literal: true

require './api/dao/purchases_dao'

module DAO
  # DAO Class to manage Trips
  class TripsDAO
    include Singleton

    def add(purchases_id_list, params)
      db.transaction do
        trip_id = db['INSERT INTO trips(departure_date, truck_id, state_id) VALUES (?, ?, ?)',
                     params[:departure_date],
                     params[:truck_id],
                     1].insert
        
        purchases_id_list.each { |purchase_id| PurchasesDAO.instance.update_trip_id(purchase_id, trip_id) }
      end
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
  end
end
