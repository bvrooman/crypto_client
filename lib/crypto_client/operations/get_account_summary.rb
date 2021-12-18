# frozen_string_literal: true

require "crypto_client/util/private_operation"
require "crypto_client/middleware/deserialize"

module CryptoClient
  module Operations
    class GetAccountSummary < Util::PrivateOperation
      self.retries = 3
      self.retriable_errors = [Errors::ServerError]

      API_METHOD = "private/get-account-summary"

      def initialize(config)
        super(config, API_METHOD)

        schema = GetAccountSummarySchema::Response
        add_middleware(Middleware::Deserialize.new(schema))
      end

      def headers(_context, *_args)
        {
          'Content-Type': "application/json"
        }
      end

      def payload(_context, currency)
        params = if currency.present?
                   { currency: currency }
                 else
                   {}
                 end
        {
          method: API_METHOD,
          params: params
        }
      end
    end
  end
end
