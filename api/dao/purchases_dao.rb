# frozen_string_literal: true

module DAO
  # DAO Class to manage Templates
  class PurchasesDAO
    include Singleton

    def add(type, params); end

    def all_without_trips
      db.fetch('SELECT * FROM purchases
                         JOIN addresses_purchases ON purchases.id = addresses_purchases.purchase_id
                         JOIN addresses ON addresses_purchases.address_id = addresses.id
                         WHERE purchases.trip_id IS NULL').all
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
