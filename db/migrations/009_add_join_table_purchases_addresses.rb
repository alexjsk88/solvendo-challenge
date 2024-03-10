# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_join_table(purchase_id: :purchases, address_id: :addresses)
  end
end
