# frozen_string_literal: true

require './api/models/trip'

module DAO
  # DAO Class to manage Templates
  class TripsDAO
    include Singleton

    def add(type, params)
      model.insert(type: type, data: params.to_json)
    end

    private

    def model
      Models::Trip
    end
  end
end
