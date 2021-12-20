# frozen_string_literal: true

module CryptoClient
  LIB_DIR = File.expand_path(".", __dir__)
  CRYPTO_CLIENT_DIR = File.join(LIB_DIR, "crypto_client")
  SCHEMAS_DIR = File.join(LIB_DIR, "schemas")
end

require_relative "crypto_client/client"
require_relative "crypto_client/config"
require_relative "crypto_client/version"
