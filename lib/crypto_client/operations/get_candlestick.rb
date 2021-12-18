# frozen_string_literal: true

require "crypto_client/util/public_operation"
require "crypto_client/middleware/deserialize"

module CryptoClient
  module Operations
    class GetCandlestick < Util::PublicOperation
      self.retries = 3
      self.retriable_errors = [Errors::ServerError]

      API_METHOD = "public/get-candlestick"

      def initialize(config)
        super(config, API_METHOD)

        schema = GetCandlestickSchema::Response
        add_middleware(Middleware::Deserialize.new(schema))
      end

      def headers(_request, *_args)
        {
          'Content-Type': "application/json"
        }
      end

      def payload(_request, instrument, interval)
        {
          instrument_name: instrument,
          timeframe: interval
        }
      end
    end
  end
end
