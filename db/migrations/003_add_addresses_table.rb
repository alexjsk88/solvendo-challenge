# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:addresses) do
      Serial      :id, primary_key: true, unique: true
      String      :address
      String      :city
      String      :zip_code
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
