# frozen_string_literal: true

require './api/models/truck'

# TODO: ds.update, ds.insert, ds.delete have to be refactored

module DAO
  # DAO Class to manage Templates
  class TrucksDAO
    include Singleton

    def add(params)
      db['INSERT INTO trucks(plate_number, max_weight_capacity, work_days, created_at, updated_at) VALUES(?, ?, ?, ?, ?)',
         params[:plate_number],
         params[:max_weight_capacity],
         params[:work_days],
         Sequel::CURRENT_TIMESTAMP,
         Sequel::CURRENT_TIMESTAMP].insert
    end

    def remove(truck_id)
      db['DELETE FROM trucks WHERE id = ?', truck_id].delete
    end

    def search_by_truck_id(truck_id)
      db.fetch('SELECT * FROM trucks WHERE id = ?', truck_id).all.first
    end

    def search_by_plate_number(plate_number)
      db.fetch('SELECT * FROM trucks WHERE plate_number = ?', plate_number).all.first
    end

    def all
      db.fetch('SELECT * FROM trucks').all
    end

    def available_list
      db.fetch('SELECT * FROM trucks WHERE is_available = true').all
    end

    def available_list_by_day(day)
      db.fetch('SELECT * FROM trucks WHERE is_available = true AND work_days LIKE ?', day).all
    end

    def average_max_weight_capacity
      db.fetch('SELECT AVG(max_weight_capacity) FROM trucks').all.first
    end

    def update_available_status(truck_id, status)
      db['UPDATE trucks SET is_available = ? WHERE id = ?', status, truck_id].update
    end

    private

    def db
      Services[:database]
    end
  end
end
