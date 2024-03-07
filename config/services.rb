# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'sequel'

# Maintains the services in memory or creates them accordingly
class Services
  extend Dry::Container::Mixin

  register :database, memoize: true do
    Sequel.sqlite('./db/database.db')
  end
end

ServicesContainer = Dry::AutoInject(Services)
