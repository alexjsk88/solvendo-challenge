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

    def schedule(scheduling_date)
      available_trucks_for_scheduling_date = analyze_trucks(scheduling_date)
      trips_to_schedule_by_date = analyze_trips(scheduling_date)

      unscheduled_trips = schedule_trucks(available_trucks_for_scheduling_date, trips_to_schedule_by_date)
      formatted_response(unscheduled_trips)
    end

    private

    def formatted_response(unscheduled_trips)
      trips = DAO::TripsDAO.instance.all_with_trucks.sort_by! { |trip| trip[:trip_id] }

      output = trips.map do |trip|
        "trip #{trip[:trip_id]} -> Truck plate: #{trip[:plate_number]}"
      end

      if unscheduled_trips && !unscheduled_trips.empty?
        unscheduled_trips.each do |trip|
          output << "trip #{trip[:trip_id]} -> Error: No trucks meet requirements"
        end
      end
      output
    end

    def schedule_trucks(trucks, trips)
      until trucks.empty? || trips.empty?
        break if trucks.first[:max_weight_capacity] < trips.first[:weight]

        truck_id = trucks.first[:id]
        db.transaction do
          DAO::TripsDAO.instance.assing_truck_to_trip(trucks.shift[:id], trips.shift[:trip_id])
          DAO::TrucksDAO.instance.update_available_status(truck_id, false)
        end
      end

      trips
    end

    # This method returns a hash with a list of available trucks grouped by the day of the week
    # for scheduling date rereceived by parameters in the HTTP request. The trucks were previously ordered by
    # 'max_weight_capacity' from the highest to the lowest.
    def analyze_trucks(scheduling_date)
      day_to_work = day_name(scheduling_date)
      sorted_trucks = DAO::TrucksDAO.instance.available_list_by_day(day_to_work).sort_by { |truck| -truck[:max_weight_capacity] }

      raise Exceptions::ScheduleIncomplete.new({ error: 'No trucks meet requirements' }) unless sorted_trucks && !sorted_trucks.empty?

      sorted_trucks
    end

    # This method returns an array with a list of trips hash with the same 'departure_date' that its received by parameters
    # in the HTTP request. The hash contains 'trip_id', 'departure_date' and 'weight' where 'weight' is the total weight of
    # all purchases for the corresponding 'trip_id'. Finally, the trips were previously ordered by 'weight' from the highest to the lowest.
    def analyze_trips(scheduling_date)
      trips = DAO::TripsDAO.instance.all_in_pending_state
      raise Exceptions::ScheduleIncomplete.new({ error: 'No trips meet requirements: state' }) unless trips && !trips.empty?

      trips_to_schedule = trips.select { |trip| trip[:departure_date].to_date == scheduling_date.to_date }
      raise Exceptions::ScheduleIncomplete.new({ error: 'No trips meet requirements' }) unless trips_to_schedule && !trips_to_schedule.empty?

      trips_to_schedule.each { |trip| trip[:weight] = DAO::TripsDAO.instance.total_weight_based_on_purschases(trip[:trip_id]) }
      trips_to_schedule.sort_by! { |trip| -trip[:weight] }
    end

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
      return unless truck_trip && truck_trip[:state] == 'On Trip'

      raise Exceptions::TripInvalidState.new({ truck: params[:plate_number] || params[:truck_id],
                                               state: truck_trip[:state] })
    end

    def day_name(date)
      date.strftime('%A').capitalize
    end

    def db
      Services[:database]
    end
  end
end
