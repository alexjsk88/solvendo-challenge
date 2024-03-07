# frozen_string_literal: true

require './test/test_helper'

class TestHealth < TestRoute
  def test_health
    get 'api/v1/health'
    assert_equal last_response_json, { 'status' => 'ok' }
  end
end
