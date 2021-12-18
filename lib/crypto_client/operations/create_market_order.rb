# frozen_string_literal: true

require_relative "create_order"

require "crypto_client/util/client_order_id_generator"

module CryptoClient
  module Operations
    class CreateMarketOrder < CreateOrder
      TYPE = "MARKET"

      def initialize(config, side)
        super(config)
        @side = side
        @client_order_id_generator = Util::ClientOrderIdGenerator.new("MARKET_#{side}")
      end

      def payload(context, instrument_name, quantity)
        client_order_id = @client_order_id_generator.generate
        super(
          context,
          client_order_id: client_order_id,
          instrument_name: instrument_name,
          quantity: quantity,
          side: @side,
          type: TYPE
        )
      end
    end
  end
end
