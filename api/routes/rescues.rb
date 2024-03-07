# frozen_string_literal: true

require './api/exceptions/core_exception.rb'

# Rescues from exceptions class
module Rescues
  def self.included(base)
    base.class_eval do
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        Logs.error("Validation error raised #{e.message}")
        error!({ status: 'fail', message: e.message }, 422)
      end
      rescue_from Exceptions::CoreException do |e|
        Logs.error("Error raised #{e.code} #{e.data.to_json}")
        error!({ status: 'fail', code: e.code, data: e.data }, e.status_code)
      end
    end
  end
end
