# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Hook sequel models
  class Truck < Sequel::Model(Services[:database][:trucks])
    unrestrict_primary_key
  end
end
