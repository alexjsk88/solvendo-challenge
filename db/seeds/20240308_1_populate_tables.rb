# frozen_string_literal: true

require 'sequel'
require 'ffaker'

Sequel.seed(:development, :test) do
  def run
    db = Services[:database]

    # Items table seed
    unique_id = generate_id
    20.times do
      insert_ds = db['INSERT INTO items(id, name, price, weight) VALUES(?, ?, ?, ?)',
                     unique_id.pop,
                     FFaker::Product.product_name,
                     FFaker::Number.decimal,
                     FFaker::Number.decimal]

      insert_ds.insert
    end

    # Seed para la tabla de purchases
    unique_id = generate_id
    10.times do
      insert_ds = db['INSERT INTO purchases(id, customer_name, delivery_date) VALUES(?, ?, ?)',
                     unique_id.pop,
                     FFaker::Name.name,
                     '2024-03-09']

      insert_ds.insert
    end

    # Seed para la tabla de addresses
    unique_id = generate_id
    10.times do
      insert_ds = db['INSERT INTO addresses(id, address, city, zip_code) VALUES(?, ?, ?, ?)',
                     unique_id.pop,
                     FFaker::Address.street_address,
                     FFaker::Address.city,
                     FFaker::AddressUS.zip_code]

      insert_ds.insert
    end

    # Seed para la tabla de trucks
    unique_id = generate_id
    10.times do
      insert_ds = db['INSERT INTO trucks(id, plate_number, max_weight_capacity, work_days) VALUES(?, ?, ?, ?)',
                     unique_id.pop,
                     FFaker::Vehicle.vin,
                     FFaker::Number.decimal,
                     %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample]

      insert_ds.insert
    end
  end
end

def generate_id
  range = (1..1000).to_a
  range.shuffle!
end
