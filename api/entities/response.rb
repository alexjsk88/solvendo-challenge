# frozen_string_literal: true

require 'grape-swagger/entity'

#
# Represent entities for documentation
#
module Entities
  #
  # Represents an entity for document the API response
  #
  class Response < Grape::Entity
    expose :status, documentation: { desc: 'Status of response', type: String, values: %w[fail success] }
    expose :data, documentation: { type: Hash, desc: 'data to return' }

    def self.example(status, data)
      represent({ status: status, data: data }).as_json
    end

    def self.default_success
      { model: self, message: 'The request succeeded',
        examples: { 'application/json' => example(:success, 1) } }
    end
  end
end
