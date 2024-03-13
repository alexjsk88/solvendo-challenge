# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:items) do
      primary_key :id
      String      :name
      BigDecimal  :price, size: [10, 2]
      BigDecimal  :weight, size: [10, 2]
      
      DateTime  :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime  :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
