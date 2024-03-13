# frozen_string_literal: true

require 'ffaker'

Sequel.seed(:development, :test) do
  def run
    db = Services[:database]

    # Items table seed
    5.times do
      db['INSERT INTO items(name, price, weight, created_at, updated_at) VALUES(?, ?, ?, ?, ?)',
         FFaker::Product.product_name,
         FFaker::Number.decimal,
         FFaker::Number.decimal,
         Sequel::CURRENT_TIMESTAMP,
         Sequel::CURRENT_TIMESTAMP].insert
    end

    # Purchases table seed
    # TODO: Update "price" and "weight" automatically with the sum of all the items "price" and "weight"
    2.times do
      db['INSERT INTO purchases(customer_name, created_at, updated_at) VALUES(?, ?, ?)',
         FFaker::Name.name,
         Date.today.prev_day.to_datetime,
         Date.today.prev_day.to_datetime].insert
    end

    # Addresses table seed
    2.times do
      db['INSERT INTO addresses(address, city, zip_code) VALUES(?, ?, ?)',
         FFaker::Address.street_address,
         FFaker::Address.city,
         FFaker::AddressUS.zip_code].insert
    end

    # Trucks table seed
    3.times do
      db['INSERT INTO trucks(plate_number, max_weight_capacity, work_days, created_at, updated_at) VALUES(?, ?, ?, ?, ?)',
         FFaker::Vehicle.vin,
         FFaker::Number.decimal,
         %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample,
         Sequel::CURRENT_TIMESTAMP,
         Sequel::CURRENT_TIMESTAMP].insert
    end
  end
end
