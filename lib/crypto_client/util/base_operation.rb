# frozen_string_literal: true

require "michigan/operation"

require "crypto_client/middleware/parse_json"

module CryptoClient
  module Util
    class BaseOperation < Michigan::Operation
      def initialize(config, operation)
        super(config.url_base + operation)

        @id_generator = IdGenerator.new

        add_middleware(Middleware::ParseJson.new)
      end

      def id(*_)
        @id_generator.generate
      end
    end
  end
end
