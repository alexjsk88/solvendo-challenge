# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Hook sequel models
  class Item < Sequel::Model(Services[:database][:items])
    unrestrict_primary_key
  end
end
