# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Address sequel model
  class Address < Sequel::Model(Services[:database][:addresses])
    unrestrict_primary_key
  end
end
