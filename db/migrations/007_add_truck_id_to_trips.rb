# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    alter_table(:trips)  do
      add_foreign_key :truck_id, :trucks, type: Integer, on_delete: :set_null, default: nil
    end
  end
end
