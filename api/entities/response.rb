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
    expose :code, documentation: { desc: 'Status code', type: Integer }
    expose :status, documentation: { desc: 'Status of response', type: String, values: %w[fail success] }
    expose :message, documentation: { desc: 'Details message', type: String }
    expose :data, documentation: { type: String, desc: 'Data fields' }

    #
    # Generate JSON formatted string to fill the Response API properties
    #
    # @param [Integer] code HTTP status code
    # @param [String] message description message
    # @param [String] data response field (omit it if you are parsing failure response)
    #
    # @return [String] JSON formatted string
    #
    def self.parse(code, message, data = '')
      case code
      when 200...300
        represent({ code: code, status: 'success', data: data }).as_json
      when 400...600
        represent({ code: code, status: 'fail', message: message }).as_json
      end
    end
  end
end
