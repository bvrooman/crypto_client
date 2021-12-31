# frozen_string_literal: true

require 'webmock'

require_relative "responses"

module CryptoClient
  module Test
    CRYPTO_BASE_URI = "https://api.crypto.com/v2/"

    def stub_crypto_request(method, uri, *responses)
      stub_request(method, /\A#{Regexp.escape(uri)}.*/).to_return(*responses)
    end

    def stub_bad_request_error
      stub_crypto_request(:any, CRYPTO_BASE_URI, bad_request_error_response)
    end

    def stub_unauthorized_error
      stub_crypto_request(:any, CRYPTO_BASE_URI, unauthorized_error_response)
    end

    def stub_server_error
      stub_crypto_request(:any, CRYPTO_BASE_URI, server_error_response)
    end

    def stub_cancel_all_orders
      stub_crypto_request(:post, CRYPTO_BASE_URI, cancel_all_orders_response)
    end

    def stub_cancel_order
      stub_crypto_request(:post, CRYPTO_BASE_URI, cancel_order_response)
    end

    def stub_get_account_summary
      stub_crypto_request(:post, CRYPTO_BASE_URI, get_account_summary_response)
    end

    def stub_get_candlestick
      stub_crypto_request(:get, CRYPTO_BASE_URI, get_candlestick_response)
    end

    def stub_get_instruments
      stub_crypto_request(:get, CRYPTO_BASE_URI, get_instruments_response)
    end

    def stub_create_order
      stub_crypto_request(:post, CRYPTO_BASE_URI, create_order_response)
    end

    def stub_get_order_detail
      stub_crypto_request(:post, CRYPTO_BASE_URI, get_order_detail_response)
    end
  end
end
