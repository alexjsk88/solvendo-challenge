# frozen_string_literal: true

require 'sequel'
require './config/services'

module Models
  # Hook sequel models
  class Hook < Sequel::Model(Services[:database][:hooks])
    unrestrict_primary_key
  end
end
