# frozen_string_literal: true

require 'simplecov'

SimpleCov.start { add_filter('/test/') }
SimpleCov.minimum_coverage(60)

require 'minitest/autorun'
require 'mocha/minitest'
require 'minitest/unit'
require 'webmock/minitest'
require 'time'
require 'colorize'
require 'minitest/reporters'
require 'rack/test'
require 'byebug'
require 'faker'

require './application'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

# class with methods to test.
class Test < Minitest::Test
  def run
    Sequel.transaction([database], rollback: :always) do
      super
    end
  end

  protected

  def database
    @database ||= Services[:database]
  end
end

# class with methods to test endpoints.
class TestRoute < Test
  include Rack::Test::Methods

  def app
    API::Root
  end

  def last_response_json
    JSON.parse(last_response.body)
  end
end
