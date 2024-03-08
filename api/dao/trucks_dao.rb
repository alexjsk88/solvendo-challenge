# frozen_string_literal: true

require './api/models/truck'

module DAO
  # DAO Class to manage Templates
  class TrucksDAO
    include Singleton

    def add(type, params)
      model.insert(type: type, data: params.to_json)
    end

    private

    def model
      Models::Truck
    end
  end
end
