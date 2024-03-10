# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    alter_table(:purchases) do
      add_foreign_key :trip_id, :trips, type: Integer, default: nil
    end
  end
end
