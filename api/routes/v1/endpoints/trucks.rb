# frozen_string_literal: true

require './api/business/trucks'

module Routes
  module V1
    module Endpoints
      # Endpoints related to Trucks
      class Trucks < Grape::API
        desc 'Get truck info'
        params do
          requires :truck_id, type: Integer, allow_blank: false, description: 'Truck ID'
        end
        get tags: ['trucks'] do
          {
            status: :success,
            data: Business::Trucks.instance.truck_info(params)
          }
        end
      end
    end
  end
end
