# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:purchases) do
      primary_key :id
      String      :customer_name
      BigDecimal  :price, size: [10, 2], default: 0
      BigDecimal  :weight, size: [10, 2], default: 0
      DateTime    :delivery_date
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
