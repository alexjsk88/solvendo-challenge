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
      purchases_by_zip_code = analyze_purchases
      schedule_trips_for_date(scheduling_date, purchases_by_zip_code)

      formatted_response
    end

    private

    def formatted_response
      dataset = DAO::PurchasesDAO.instance.all_with_trips
      trip_id_hash = dataset.sort_by! { |trip| trip[:trip_id] }.group_by { |trip| trip[:trip_id] }

      trip_id_hash.map do |trip_id, trips|
        zip_codes = trips.map { |trip| trip[:zip_code] }.uniq.join(' ')

        "trip #{trip_id} -> zip code: #{zip_codes}"
      end
    end

    def schedule_trips_for_date(scheduling_date, purchases_by_zip_code)
      purchases_id_list = []
      zip_counter = 0

      purchases_by_zip_code.each_key do |zip_code|
        zip_counter += 1
        purchases_id_list.unshift(*purchases_by_zip_code[zip_code].map { |purchase| purchase[:purchase_id] })

        if zip_counter > 2 || zip_code == purchases_by_zip_code.keys.last
          zip_counter = 0
          create_trip(purchases_id_list, scheduling_date)
          purchases_id_list.clear
        end
      end
    end

    def create_trip(purchases_id_list, scheduling_date)
      db.transaction do
        trip_id = DAO::TripsDAO.instance.add({ departure_date: scheduling_date })
        DAO::PurchasesDAO.instance.update_trip_id(trip_id[:id], purchases_id_list, scheduling_date)
      end
    end

    # This method returns a hash with all purchases that have no trip assigned, from yesterday, ordered by "weight"
    # from the lowest to the highest and grouped by zip code.
    def analyze_purchases
      yesterday = Date.today.prev_day.to_date
      purchases_from_yesterday = DAO::PurchasesDAO.instance.all_without_trips
                                                  .sort_by { |purchase| purchase[:weight] }
                                                  .select { |purchase| purchase[:created_at].to_date == yesterday }

      raise Exceptions::ScheduleIncomplete.new({ error: 'No purchase to delivery' }) if purchases_from_yesterday.empty?

      purchases_from_yesterday.group_by { |hash| hash[:zip_code] }
    end

    # This method returns a hash with a list of available trucks grouped by the day of the week
    # and previously ordered by "max_weight_capacity' from the highest to the lowest.

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
