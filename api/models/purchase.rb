# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Hook sequel models
  class Purchase < Sequel::Model(Services[:database][:purchases])
    unrestrict_primary_key
  end
end
