# frozen_string_literal: true

require 'grape-swagger/entity'
require './api/entities/response'

# This module represents entities for documentation
module Entities
  # This class represents an entity for documenting the Truck model
  class Truck < Grape::Entity
    # Plate number of the truck
    expose :plate_number, documentation: {
      type: String,
      desc: 'Plate number of the truck',
      required: true
    }

    # Max weight capacity that the truck can carry without risks
    expose :max_weight_capacity, documentation: {
      type: BigDecimal,
      desc: 'Max weight capacity that the truck can carry without risks',
      required: true
    }

    # Name of the week day that the truck works
    expose :work_days, documentation: {
      type: String,
      description: 'Name of the week day that the truck works'
    }

    # Is the truck available to be scheduled with trips?
    expose :is_available, documentation: {
      type: ::Grape::API::Boolean,
      values: ['true', 'false'],
      description: 'Is the truck available to be scheduled with trips?'
    }
  end
end

