# frozen_string_literal: true

require './api/models/hook'

module DAO
  # DAO Class to manage Templates
  class HooksDAO
    include Singleton

    def add(type, params)
      model.insert(type: type, data: params.to_json)
    end

    private

    def model
      Models::Hook
    end
  end
end
