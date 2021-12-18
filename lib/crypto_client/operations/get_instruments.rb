# frozen_string_literal: true

require "crypto_client/util/public_operation"
require "crypto_client/middleware/deserialize"

module CryptoClient
  module Operations
    class GetInstruments < Util::PublicOperation
      self.retries = 3
      self.retriable_errors = [Errors::ServerError]

      API_METHOD = "public/get-instruments"

      def initialize(config)
        super(config, API_METHOD)

        schema = GetInstrumentsSchema::Response
        add_middleware(Middleware::Deserialize.new(schema))
      end

      def headers(_context, *_args)
        {
          'Content-Type': "application/json"
        }
      end

      def payload(_context)
        {}
      end
    end
  end
end
