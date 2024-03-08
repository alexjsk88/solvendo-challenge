# frozen_string_literal: true

Sequel.seed(:development, :test) do
  def run
    db = Services[:database]
    states = db[:states]
    states.insert(id: 0, state: 'Pending')
    states.insert(id: 1, state: 'On Trip')
    states.insert(id: 2, state: 'Delivered')
  end
end


