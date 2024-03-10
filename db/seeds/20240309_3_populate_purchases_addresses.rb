# frozen_string_literal: true

require 'sequel'
require 'ffaker'

# Purchase-Items table seed
Sequel.seed(:development, :test) do
  def run
    db = Services[:database]

    purchases_list = db.fetch('SELECT id FROM purchases').all

    addresses_list = db.fetch('SELECT id FROM addresses').all

    purchases_list.each do |purchase|
      address = addresses_list.sample
      ds = db['INSERT INTO addresses_purchases VALUES (?, ?)', address[:id], purchase[:id]]
      ds.insert
    end
  end
end
