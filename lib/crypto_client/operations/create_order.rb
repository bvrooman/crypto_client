# frozen_string_literal: true

require "crypto_client/util/private_operation"
require "crypto_client/middleware/deserialize"

module CryptoClient
  module Operations
    class CreateOrder < Util::PrivateOperation
      API_METHOD = "private/create-order"

      def initialize(config)
        super(config, API_METHOD)

        schema = CreateOrderSchema::Response
        add_middleware(Middleware::Deserialize.new(schema))
      end

      def headers(_context, *_args)
        {
          'Content-Type': "application/json"
        }
      end

      def payload(_context,
                  client_order_id:,
                  instrument_name:,
                  type:,
                  side:,
                  price: nil,
                  quantity: nil,
                  notional: nil,
                  time_in_force: nil,
                  exec_inst: nil,
                  trigger_price: nil)
        params = {
          instrument_name: instrument_name,
          side: side,
          type: type,
          price: price,
          quantity: quantity,
          notional: notional,
          client_oid: client_order_id,
          time_in_force: time_in_force,
          exec_inst: exec_inst,
          trigger_price: trigger_price
        }.compact
        {
          method: API_METHOD,
          params: params
        }
      end
    end
  end
end
