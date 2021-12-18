# frozen_string_literal: true

require "crypto_client/util/private_operation"
require "crypto_client/middleware/deserialize"

module CryptoClient
  module Operations
    class CancelOrder < Util::PrivateOperation
      self.retries = 3
      self.retriable_errors = [Errors::ServerError]

      API_METHOD = "private/cancel-order"

      def initialize(config)
        super(config, API_METHOD)

        schema = AsynchronousResponseSchema::Response
        add_middleware(Middleware::Deserialize.new(schema))
      end

      def headers(_request, *_args)
        {
          'Content-Type': "application/json"
        }
      end

      def payload(_request, instrument_name, order_id)
        params = {
          instrument_name: instrument_name,
          order_id: order_id
        }
        {
          method: API_METHOD,
          params: params
        }
      end
    end
  end
end
