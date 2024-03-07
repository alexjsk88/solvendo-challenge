# frozen_string_literal: true

require 'grape-swagger/entity'
require './api/entities/response'

#
# Represent entities for documentation
#
module Entities
  #
  # Represents an entity for document the Document model
  #
  class Document < Grape::Entity
    expose :id, documentation: { type: String, required: true }
    expose :name, documentation: { type: String, desc: 'Name of the uploaded file', required: true }
    expose :fields, documentation: { type: String, desc: 'Short description of your template', required: true } # TODO
    expose :callback_url, documentation: { type: String, description: '	The callback URL to be POSTed when everybody sign' }
    expose :source_id, documentation: { type: String, desc: 'HTML content of document to be generated' } # TODO
    expose :external_document_id,
           documentation: { type: String, description: 'A unique id for you to identify the document in the response or fetch it' }
    expose :status, documentation: { type: String, values: ['not signed', 'signed'] }

    #
    # Specific class method to document according to Swagger, the "successfull" response for "add_with_template" method on "Bussiness::Document"
    #
    # @return [String] Formatted string to generate the Swagger response "example" field
    #
    def self.add_with_template_success
      { examples: { 'application/json' => Entities::Response.parse(201, 'succesful added', "{ document_id: '29f3cb01-744d-4eae-8718-213aec8a1678',
                                                                                              widget_id: 'ABCD1234' }") } }
    end

    #
    # Specific class method to document according to Swagger, the "failure" response for "add_with_template" method on "Bussiness::Document"
    #
    # @return [String] Formatted string to generate the Swagger response "example" field
    #
    def self.add_with_template_fail
      [
        Entities::Response.parse(422, 'INVALID_TEMPLATE'),
        Entities::Response.parse(422, 'ALREADY_REGISTERED_DOCUMENT')
      ]
    end
  end
end
