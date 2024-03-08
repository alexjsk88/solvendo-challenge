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

    DB = Services[:database]
    states = DB[:states]
    states.insert(id: 0, state: 'Pending')
    states.insert(id: 1, state: 'On Trip')
    states.insert(id: 2, state: 'Delivered')
  end
end
