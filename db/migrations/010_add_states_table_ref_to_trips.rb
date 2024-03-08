# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:states) do
      Integer      :id, primary_key: true, unique: true
      String      :state
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end

    alter_table(:trips) do
      add_foreign_key :state_id, :states
    end
  end
end
