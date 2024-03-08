# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Hook sequel models
  class Trip < Sequel::Model(Services[:database][:trips])
    unrestrict_primary_key
  end
end
