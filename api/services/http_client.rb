# frozen_string_literal: true

require 'httparty'

class HttpClient
  class << self
    def post(url, data)
      options = {
        headers: { 'Content-Type': 'application/json' },
        body: data.to_json
      }

      response = HTTParty.post(url, options)
      JSON.parse(response.body, symbolize_names: true)[:data]
    end
  end
end
