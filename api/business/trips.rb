# frozen_string_literal: true

require './api/dao/purchases_dao'
require './api/dao/trucks_dao'
require './api/services/http_client'
require './api/exceptions/schedule_incomplete'

module Business
  # Handle business logic for trips
  class Trips
    include Singleton

    def trips
      DAO::TripsDAO.instance.all
    end

    def schedule(scheduling_date)
      purchases_by_zip_code = purchases_analyze
      available_trucks_for_scheduling_date = trucks_analyze(scheduling_date)

      until available_trucks_for_scheduling_date.empty?
        truck = available_trucks_for_scheduling_date.shift
        schedule_truck_for_date(scheduling_date, truck, purchases_by_zip_code)
      end

      formatted_response
    end

    private

    def formatted_response
      dataset = DAO::PurchasesDAO.instance.just_with_trips
      trip_id_hash = dataset.sort_by! { |trip| trip[:trip_id] }.group_by { |trip| trip[:trip_id] }

      trip_output = trip_id_hash.map do |trip_id, trips|
        zip_codes = trips.map { |trip| trip[:zip_code] }.join(' ')
        "trip #{trip_id} -> zip code: #{zip_codes}"
      end

      truck_output = trip_id_hash.map do |trip_id, trips|
        plate_number = trips.first[:plate_number]
        "trip #{trip_id} -> Truck plate: #{plate_number}"
      end

      {
        trips: trip_output,
        truck: truck_output
      }
    end

    def schedule_truck_for_date(scheduling_date, truck, purchases_by_zip_code)
      purchases_id_list = []
      zip_counter = 0
      weight_sum = 0

      purchases_by_zip_code.each_key do |zip_code|
        begin
          break if truck_be_full?(truck, weight_sum, purchases_by_zip_code[zip_code])

          weight_sum += purchases_by_zip_code[zip_code].first[:weight]
          purchases_id_list << purchases_by_zip_code[zip_code].shift[:purchase_id]
        end while !purchases_by_zip_code[zip_code].empty?

        if purchases_by_zip_code[zip_code].empty?                       # * Se acabaron las ventas para este zip_code
          purchases_by_zip_code.delete(zip_code)
          if zip_counter < 3                                            # * Pregunto si ya el camion tiene los 3 zip_code permitidos
            zip_counter += 1                                            # * Si no, incremento el contador de zip_code permitidos
            next                                                        # * Siguiente zip_code
          else
            create_trip(purchases_id_list, scheduling_date, truck[:id]) # * Crear viaje porque el camion tiene los 3 zip_code permitidos
            break
          end
        end
        if truck_be_full?(truck, weight_sum, purchases_by_zip_code[zip_code])
          create_trip(purchases_id_list, scheduling_date, truck[:id]) # * Crear viaje porque el camion no tiene capacidad
          break
        end
      end
    end

    def create_trip(purchases_id_list, scheduling_date, truck_id)
      DAO::TripsDAO.instance.add(purchases_id_list, { departure_date: scheduling_date,
                                                      truck_id: truck_id })

      change_truck_available_status(truck_id)
    end

    def change_truck_available_status(truck_id)
      DAO::TrucksDAO.instance.update_available_status(truck_id, false)
    end

    def truck_be_full?(truck, truck_weight, purchase_with_incoming_weight)
      (truck_weight + purchase_with_incoming_weight.first[:weight] > truck[:max_weight_capacity])
    end

    # This method returns a hash with all purchases that have no trip assigned, from yesterday, ordered by "weight"
    # from the lowest to the highest and grouped by zip code.
    def purchases_analyze
      yesterday = Date.today.prev_day.to_date
      purchases_from_yesterday = DAO::PurchasesDAO.instance.all_without_trips
                                                  .sort_by { |purchase| purchase[:weight] }
                                                  .select { |purchase| purchase[:created_at].to_date == yesterday }
      
      raise Exceptions::ScheduleIncomplete.new({ error: 'No purchase to delivery' }) if purchases_from_yesterday.empty?

      purchases_from_yesterday.group_by { |hash| hash[:zip_code] }
    end

    # This method returns a hash with a list of available trucks grouped by the day of the week
    # and previously ordered by "max_weight_capacity' from the highest to the lowest.
    def trucks_analyze(scheduling_date)
      day_to_work = day_name(scheduling_date)
      sorted_trucks = DAO::TrucksDAO.instance.available_list_by_day(day_to_work).sort_by { |truck| -truck[:max_weight_capacity] }

      raise Exceptions::ScheduleIncomplete.new({ error: 'No trucks meet requirements' }) if sorted_trucks.empty?

      sorted_trucks
    end

    def day_name(date)
      date.strftime('%A').capitalize
    end

    def db
      Services[:database]
    end
  end
end

#
# .select { |truck| truck[:work_days].include?(today_name) }
