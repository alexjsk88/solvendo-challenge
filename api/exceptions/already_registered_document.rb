# frozen_string_literal: true

require_relative 'core_exception'

module Exceptions
  # Class to manage AlreadyRegisteredDocument
  class AlreadyRegisteredDocument < CoreException
    def code
      'ALREADY_REGISTERED_DOCUMENT'
    end

    def status_code
      422
    end
  end
end
