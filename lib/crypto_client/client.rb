# frozen_string_literal: true

require "faraday"

require_relative "errors"
require_relative "operations"

module CryptoClient
  class Client
    attr_reader :config, :endpoint_get_candlestick, :endpoint_get_instruments, :endpoint_cancel_all_orders,
                :endpoint_cancel_order, :endpoint_create_market_buy_order, :endpoint_create_market_sell_order,
                :endpoint_get_account_summary, :endpoint_get_order_detail

    def initialize(type)
      @config = Operations::Config.new(type)

      @endpoint_get_candlestick = Operations::GetCandlestick.new(@config)
      @endpoint_get_instruments = Operations::GetInstruments.new(@config)

      @endpoint_get_account_summary = Operations::GetAccountSummary.new(@config)
      @endpoint_create_market_buy_order = Operations::CreateMarketOrder.new(@config, "BUY")
      @endpoint_create_market_sell_order = Operations::CreateMarketOrder.new(@config, "SELL")
      @endpoint_get_order_detail = Operations::GetOrderDetail.new(@config)
      @endpoint_cancel_all_orders = Operations::CancelAllOrders.new(@config)
      @endpoint_cancel_order = Operations::CancelOrder.new(@config)
    end

    def get_candlestick(instrument, interval)
      response = endpoint_get_candlestick.call(instrument, interval) do |method, url, request|
        payload = request.payload
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.candlesticks
    end

    def get_instruments
      response = endpoint_get_instruments.call do |method, url, request|
        payload = request.payload
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.instruments
    end

    # AUTHENTICATED ENDPOINTS

    def cancel_all_orders(instrument_name)
      endpoint_cancel_all_orders.call(instrument_name) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
    end

    def cancel_order(instrument_name, order_id)
      endpoint_cancel_order.call(instrument_name, order_id) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
    end

    def create_market_buy_order(instrument_name, quantity)
      response = endpoint_create_market_buy_order.call(instrument_name, quantity) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.order
    end

    def create_market_sell_order(instrument_name, quantity)
      response = endpoint_create_market_sell_order.call(instrument_name, quantity) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.order
    end

    def get_account_summary(currency = nil)
      response = endpoint_get_account_summary.call(currency) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.accounts
    end

    def get_order_detail(order_id)
      response = endpoint_get_order_detail.call(order_id) do |method, url, request|
        payload = request.payload.to_json
        headers = request.headers
        http_client.method(method).call(url, payload, headers)
      rescue Faraday::BadRequestError => e
        raise Errors::BadRequestError.new(e.response_status, e.message)
      rescue Faraday::UnauthorizedError => e
        raise Errors::UnauthorizedError.new(e.response_status, e.message)
      rescue Faraday::ServerError => e
        raise Errors::ServerError.new(e.response_status, e.message)
      end
      response.order
    end

    private

    def http_client
      @http_client ||= Faraday.new do |client|
        client.use Faraday::Response::RaiseError
      end
    end
  end
end
