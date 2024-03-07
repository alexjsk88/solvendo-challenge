# frozen_string_literal: true

require './api/business/hooks'

module Routes
  module V1
    # Endpoints related to Templates
    class Hooks < Grape::API
      resource :hook do
        resource :mifiel do
          desc 'Get the result of Mifiel sign operation' do
            failure [{ code: 500, message: 'Invalid singing process' }]
          end
          post :sign, tags: ['hooks'] do
            status 200
            {
              status: :success,
              data: Business::Hooks.instance.handle_mifiel_sign(params)
            }
          end
        end
      end
    end
  end
end
