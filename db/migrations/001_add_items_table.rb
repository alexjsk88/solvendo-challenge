# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:items) do
      Serial    :id, primary_key: true, unique: true
      String    :name
      BigDecimal :price, size: [10, 2]
      BigDecimal :weight, size: [10, 2]
      
      DateTime  :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
