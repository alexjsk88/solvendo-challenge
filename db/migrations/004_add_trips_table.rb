# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:trips) do
      Serial      :id, primary_key: true, unique: true
      DateTime    :departure_date
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
