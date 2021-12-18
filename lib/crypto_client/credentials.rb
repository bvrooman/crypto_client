# frozen_string_literal: true

require "crypto_client/config"

module CryptoClient
  class Credentials
    attr_reader :key, :secret

    def initialize
      @key = CryptoClient.config.api_key
      @secret = CryptoClient.config.api_secret
    end
  end
end
