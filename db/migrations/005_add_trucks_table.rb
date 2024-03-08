# frozen_string_literal: true

Sequel.migration do
  transaction

  up do
    create_table(:trucks) do
      Serial      :id, primary_key: true, unique: true
      String      :plate_number
      BigDecimal  :max_weight_capacity, size: [10, 2]
      String      :work_days, default: 'Monday'
      TrueClass   :is_available, default: true
      
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
