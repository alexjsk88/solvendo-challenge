# frozen_string_literal: true

require 'securerandom'

class UUIDGenerator
  include Singleton

  def generate
    Time.now.to_i.to_s(16).rjust(8, '0')[0..7] + SecureRandom.hex(8)
  end
end
