# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Item sequel models
  class Item < Sequel::Model(Services[:database][:items])
    unrestrict_primary_key
  end
end
