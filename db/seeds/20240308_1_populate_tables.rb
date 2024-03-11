# frozen_string_literal: true

require 'ffaker'

Sequel.seed(:development, :test) do
  def run
    db = Services[:database]

    # Items table seed
    20.times do
      insert_ds = db['INSERT INTO items(name, price, weight) VALUES(?, ?, ?)',
                     FFaker::Product.product_name,
                     FFaker::Number.decimal,
                     FFaker::Number.decimal]

      insert_ds.insert
    end

    # Seed para la tabla de purchases
    10.times do
      insert_ds = db['INSERT INTO purchases(customer_name, delivery_date) VALUES(?, ?)',
                     FFaker::Name.name,
                     '2024-03-09']

      insert_ds.insert
    end

    # Seed para la tabla de addresses
    10.times do
      insert_ds = db['INSERT INTO addresses(address, city, zip_code) VALUES(?, ?, ?)',
                     FFaker::Address.street_address,
                     FFaker::Address.city,
                     FFaker::AddressUS.zip_code]

      insert_ds.insert
    end

    # Seed para la tabla de trucks
    10.times do
      insert_ds = db['INSERT INTO trucks(plate_number, max_weight_capacity, work_days) VALUES(?, ?, ?)',
                     FFaker::Vehicle.vin,
                     FFaker::Number.decimal,
                     %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample]

      insert_ds.insert
    end
  end
end

