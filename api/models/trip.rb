# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Trip sequel models
  class Trip < Sequel::Model(Services[:database][:trips])
    unrestrict_primary_key
  end
end
