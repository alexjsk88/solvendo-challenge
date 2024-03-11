# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    alter_table(:items) do
      add_foreign_key :purchase_id, :purchases, type: Integer
    end
  end
end
