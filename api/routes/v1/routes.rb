# frozen_string_literal: true

require 'grape-swagger'
require_relative '../../entities/truck'
require_relative '../rescues'
require_relative 'endpoints/trucks'
require_relative '../../business/trucks'
require_relative '../../business/trips'

module Routes
  module V1
    # Entry point class for routes
    class API < Grape::API
      include Rescues

      format :json
      content_type :json, 'application/json'

      prefix :api
      version :v1

      desc 'Test API working status'
      get :health, tags: ['health'] do
        { 
          status: :ok 
        }
      end

      resource :trucks do
        desc 'Get trucks list'
        get tags: ['trucks'] do
          {
            status: :success,
            data: Business::Trucks.instance.trucks
          }
        end

        desc 'Get available trucks list'
        get :available, tags: ['trucks'] do
          {
            status: :success,
            data: Business::Trucks.instance.available_trucks
          }
        end

        desc 'Schedule the truck for delivery trips using a date for scheduling as param' do
          success Entities::Response.default_success
          failure [{ code: 500, message: 'Invalid scheduling process for trucks' }]          
        end
        params do
          requires :date, allow_blank: false, type: DateTime, description: 'Scheduling date'
        end
        get :schedule, tags: ['trucks'] do
          {
            status: :success,
            data: Business::Trucks.instance.schedule(params[:date])
          }
        end

        route_param :truck_id do
          mount Endpoints::Trucks
        end
      end

      resource :trips do
        desc 'Get trips list'
        get tags: ['trips'] do
          {
            status: :success,
            data: Business::Trips.instance.trips
          }
        end

        desc 'Schedule delivery trips using a date for scheduling as param' do
          success Entities::Response.default_success
          failure [{ code: 500, message: 'Invalid scheduling process for trips' }]
        end
        params do
          requires :date, allow_blank: false, type: DateTime, description: 'Scheduling date'
        end
        get :schedule, tags: ['trips'] do
          {
            status: :success,
            data: Business::Trips.instance.schedule(params[:date])
          }
        end
      end

      add_swagger_documentation(
        host: 'solvendo-api',
        api_version: 'v1',
        schemes: %w[http],
        doc_version: '0.0.1',
        array_use_braces: true,
        info: {
          basepath: '/api/v1',
          title: 'Solvendo API',
          description: 'Documentation for Solvendo API'
        },
        models: [
          ::Entities::Truck,
        ],
        tags: [
          { name: 'trucks', description: 'Endpoint for trucks operations' },
          { name: 'trips', description: 'Endpoint for trips operations' },
          { name: 'health', description: 'API working status' }
        ]
      )
    end    
  end
end
