# frozen_string_literal: true

require './api/dao/trucks_dao'
require './api/dao/trips_dao'
require './api/services/http_client'
require './api/utils/constants'
require './api/exceptions/truck_not_found'
require './api/exceptions/truck_already_exist'
require './api/exceptions/trip_invalid_state'

module Business
  # Handle business logic for trucks
  class Trucks
    include Singleton

    def add(params)
      existing_truck = DAO::TrucksDAO.instance.search_by_plate_number(params[:plate_number])
      raise Exceptions::TruckAlreadyExist.new({ plate_number: params[:plate_number] }) if existing_truck

      DAO::TrucksDAO.instance.add(params)
    end

    def remove(params)
      truck_id = find_truck_id(params)
      raise_exceptions_if_needed(params, truck_id)

      DAO::TrucksDAO.instance.remove(truck_id)
    end

    def trucks
      DAO::TrucksDAO.instance.all
    end

    def available_list
      DAO::TrucksDAO.instance.available_list
    end

    def truck_info(params)
      existing_truck = DAO::TrucksDAO.instance.search_by_truck_id(params[:truck_id])
      raise Exceptions::TruckNotFound.new({}) unless existing_truck

      {
        plate_number: existing_truck[:plate_number],
        max_weight_capacity: existing_truck[:max_weight_capacity],
        work_days: existing_truck[:work_days],
        is_available: existing_truck[:is_available]
      }
    end

    private

    def find_truck_id(params)
      if params[:truck_id]
        params[:truck_id]
      else
        result = DAO::TrucksDAO.instance.search_by_plate_number(params[:plate_number])
        result[:id] if result
      end
    end

    def raise_exceptions_if_needed(params, truck_id)
      raise Exceptions::TruckNotFound.new({ truck: params[:plate_number] || params[:truck_id] }) unless truck_id

      truck_trip = DAO::TripsDAO.instance.search_truck_on_trips(truck_id)
      if truck_trip && truck_trip[:state] == 'On Trip'
        raise Exceptions::TripInvalidState.new({ truck: params[:plate_number] || params[:truck_id],
                                                 state: truck_trip[:state] })
      end
    end

    def db
      Services[:database]
    end
  end
end
