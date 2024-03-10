# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:trips) do
      primary_key :id
      DateTime    :departure_date
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
