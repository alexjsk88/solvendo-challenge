# frozen_string_literal: true

require 'sequel'
require 'sequel/extensions/seed'
require_relative 'services'

class Seeder
  DEFAULT_ENVIRONMENT = :development

  class << self
    def run_seeds!(environment = nil)
      environment ||= DEFAULT_ENVIRONMENT
      Sequel::Seed.setup(environment)
      Sequel::Seeder.apply(Services[:database], './db/seeds')
    end
  end
end
