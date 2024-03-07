# frozen_string_literal: true

require 'grape'
require './api/routes/v1/routes'
require './config/services'
require './api/utils/constants'
require './config/logger'

module API
  # Grape API class. We will inherit from it in our future controllers.
  class Root < Grape::API
    format :json
    content_type :json, 'application/json'

    mount Routes::V1::API
  end
end
