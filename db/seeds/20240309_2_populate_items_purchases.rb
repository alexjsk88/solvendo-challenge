# frozen_string_literal: true

require 'sequel'
require 'ffaker'

# Purchase-Items table seed
Sequel.seed(:development, :test) do
  def run
    db = Services[:database]

    purchases_list = db.fetch('SELECT id FROM purchases WHERE NOT EXISTS (
                                    SELECT purchase_id
                                    FROM items
                                    WHERE purchases.id = items.purchase_id
    )').all

    items_list = db.fetch('SELECT id FROM items WHERE purchase_id IS NULL').all

    purchases_list.each do |purchase|
      item_id = items_list.shuffle!.pop[:id]
      db['UPDATE items SET purchase_id = ?, updated_at = ? WHERE id = ?', purchase[:id], Sequel::CURRENT_TIMESTAMP, item_id].update

      price = db.fetch('SELECT SUM(price) AS total FROM items WHERE purchase_id = ? GROUP BY purchase_id', purchase[:id])
      db['UPDATE purchases SET price = ?, updated_at = ? WHERE id = ?', price.first[:total], Sequel::CURRENT_TIMESTAMP, purchase[:id]].update

      weight = db.fetch('SELECT SUM(weight) AS total FROM items WHERE purchase_id = ? GROUP BY purchase_id', purchase[:id])
      db['UPDATE purchases SET weight = ?, updated_at = ? WHERE id = ?', weight.first[:total], Sequel::CURRENT_TIMESTAMP, purchase[:id]].update
    end
  end
end
