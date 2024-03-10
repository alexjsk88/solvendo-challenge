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
      ds = db['UPDATE items SET purchase_id = ? WHERE id = ?', purchase[:id], item_id]
      ds.update
    end
  end
end
