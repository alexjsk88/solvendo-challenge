# frozen_string_literal: true

module DAO
  # DAO Class to manage Templates
  class PurchasesDAO
    include Singleton

    def add(type, params); end

    def all_without_trips
      db.fetch('SELECT p.weight, p.delivery_date, p.created_at, p.trip_id,
                       ap.address_id, ap.purchase_id, a.zip_code FROM purchases AS p
                       JOIN addresses_purchases as ap ON p.id = ap.purchase_id
                       JOIN addresses AS a ON ap.address_id = a.id
                       WHERE p.trip_id IS NULL').all
    end

    def just_with_trips
      db.fetch('SELECT p.created_at, p.trip_id, ap.address_id, ap.purchase_id, a.zip_code, tp.departure_date,
                       tp.state_id, tp.truck_id, tk.plate_number
                       FROM purchases AS p
                       JOIN addresses_purchases as ap ON p.id = ap.purchase_id
                       JOIN addresses AS a ON ap.address_id = a.id
                       JOIN trips AS tp ON p.trip_id = tp.id
                       JOIN trucks AS tk ON tp.truck_id = tk.id
                       WHERE p.trip_id IS NOT NULL').all
    end

    def search_truck_on_trips(truck_id)
      db.fetch('SELECT states.state FROM trucks
                                    JOIN trips ON trucks.id = trips.truck_id
                                    JOIN states ON trips.state_id = states.id
                                    WHERE trucks.id = ?', truck_id).all.first
    end

    def update_trip_id(trip_id, purchase_id)
      db['UPDATE purchases SET trip_id = ? WHERE id = ?', purchase_id, trip_id].update
    end

    private

    def db
      Services[:database]
    end
  end
end
