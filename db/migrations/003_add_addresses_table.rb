# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:addresses) do
      primary_key :id
      String      :address
      String      :city
      String      :zip_code
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime    :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
