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
    end

    private

    def model
      Models::Truck
    end
  end
end
