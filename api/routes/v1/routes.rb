# frozen_string_literal: true

require 'grape-swagger'
require_relative '../../entities/document'
require_relative '../rescues'
require_relative 'hooks'

module Routes
  module V1
    # Entry point class for routes
    class API < Grape::API
      include Rescues

      prefix :api
      version :v1

      get :health, tags: ['health'] do
        { status: :ok }
      end

      mount Routes::V1::Hooks

      add_swagger_documentation(
        host: 'document-service',
        api_version: 'v1',
        schemes: %w[http],
        doc_version: '0.0.1',
        array_use_braces: true,
        info: {
          basepath: '/api/v1',
          title: 'Document Service API Docs',
          description: 'Documentation for Documents Service API'
        },
        models: [
          ::Entities::Document,
          ::Entities::Response
        ],
        tags: [
          { name: 'templates', description: 'Operations about documents using templates' },
          { name: 'hooks', description: 'Operation to sign on Mifiel' },
          { name: 'health', description: 'API working status' }
        ]
      )
    end
  end
end
