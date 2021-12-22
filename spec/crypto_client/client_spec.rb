# frozen_string_literal: true

require "crypto_client/client"
require "crypto_client/config"
require "crypto_client/operations/config"
require "crypto_client/util/id_generator"
require "crypto_client/util/nonce_generator"

RSpec.describe CryptoClient::Client, type: :client do
  def signature_for(payload)
    secret = config.credentials.secret
    param_string = +""
    sorted_params = payload[:params].sort_by { |key, _| key }.to_h
    sorted_params.each do |key, value|
      param_string += key.to_s
      param_string += value.to_s
    end
    payload_str =
      payload[:method].to_s + payload[:id].to_s + payload[:api_key].to_s + param_string + payload[:nonce].to_s
    OpenSSL::HMAC.hexdigest("SHA256", secret, payload_str)
  end

  subject(:client) { described_class.new(config) }

  let(:config) { CryptoClient::Operations::Config.new(:prod) }
  let(:base_url) { "https://api.crypto.com/v2" }
  let(:id_generator) { CryptoClient::Util::IdGenerator.new }
  let(:id) { 90_210 }
  let(:nonce_generator) { CryptoClient::Util::NonceGenerator.new }
  let(:nonce) { 100_000_000 }

  before do
    Modelix.config.api_key = "abc-def-ghi"
    Modelix.config.api_secret = "123-456-789"

    allow_any_instance_of(Object).to receive(:sleep)
    allow(CryptoClient::Util::IdGenerator).to receive(:new).and_return(id_generator)
    allow(id_generator).to receive(:generate).and_return(id)
    allow(CryptoClient::Util::NonceGenerator).to receive(:new).and_return(nonce_generator)
    allow(nonce_generator).to receive(:generate).and_return(nonce)
  end

  describe "cancel_all_orders" do
    let(:url) { %r{#{base_url}/private/cancel-all-orders} }

    it "makes a request to the expected URL" do
      stub_cancel_all_orders
      client.cancel_all_orders("BTC_USDT")
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_cancel_all_orders
      client.cancel_all_orders("BTC_USDT")
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        body >= {
          method: "private/cancel-all-orders",
          params: { "instrument_name" => "BTC_USDT" },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
      end).to have_been_made
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.cancel_all_orders("BTC_USDT")
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.cancel_all_orders("BTC_USDT")
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.cancel_all_orders("BTC_USDT")
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.cancel_all_orders("BTC_USDT")
      rescue StandardError
        # Ignore
      end
      expect(a_request(:post, url)).to have_been_made.times(4)
    end
  end

  describe "cancel_order" do
    let(:url) { %r{#{base_url}/private/cancel-order} }

    it "makes a request to the expected URL" do
      stub_cancel_order
      client.cancel_order("BTC_USDT", "123")
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_cancel_order
      client.cancel_order("BTC_USDT", "123")
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        body >= {
          method: "private/cancel-order",
          params: {
            "instrument_name" => "BTC_USDT",
            "order_id" => "123"
          },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
      end).to have_been_made
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.cancel_order("BTC_USDT", "123")
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.cancel_order("BTC_USDT", "123")
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.cancel_order("BTC_USDT", "123")
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.cancel_order("BTC_USDT", "123")
      rescue StandardError
        # Ignore
      end
      expect(a_request(:post, url)).to have_been_made.times(4)
    end
  end

  describe "create_market_buy_order" do
    let(:url) { %r{#{base_url}/private/create-order} }
    let(:client_order_id_generator) { CryptoClient::Util::ClientOrderIdGenerator.new("MARKET_BUY") }
    let(:client_order_id) { "MARKET_BUY_123" }

    before do
      allow(CryptoClient::Util::ClientOrderIdGenerator).to receive(:new).and_return(client_order_id_generator)
      allow(client_order_id_generator).to receive(:generate).and_return(client_order_id)
    end

    it "makes a request to the expected URL" do
      stub_create_order
      client.create_market_buy_order("BTC_USDT", 100)
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_create_order
      client.create_market_buy_order("BTC_USDT", 100)
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        expected_body = {
          method: "private/create-order",
          params: {
            "instrument_name" => "BTC_USDT",
            "side" => "BUY",
            "type" => "MARKET",
            "quantity" => 100,
            "client_oid" => client_order_id
          },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
        body >= expected_body
      end).to have_been_made
    end

    it "returns an order receipt" do
      stub_create_order
      order = client.create_market_buy_order("BTC_USDT", 100)
      expect(order.order_id).to be_a String
      expect(order.client_order_id).to be_a String
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.create_market_buy_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.create_market_buy_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.create_market_buy_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::ServerError
    end
  end

  describe "create_market_sell_order" do
    let(:url) { %r{#{base_url}/private/create-order} }
    let(:client_order_id_generator) { CryptoClient::Util::ClientOrderIdGenerator.new("MARKET_SELL") }
    let(:client_order_id) { "MARKET_SELL_123" }

    before do
      allow(CryptoClient::Util::ClientOrderIdGenerator).to receive(:new).and_return(client_order_id_generator)
      allow(client_order_id_generator).to receive(:generate).and_return(client_order_id)
    end

    it "makes a request to the expected URL" do
      stub_create_order
      client.create_market_sell_order("BTC_USDT", 100)
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_create_order
      client.create_market_sell_order("BTC_USDT", 100)
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        expected_body = {
          method: "private/create-order",
          params: {
            "instrument_name" => "BTC_USDT",
            "side" => "SELL",
            "type" => "MARKET",
            "quantity" => 100,
            "client_oid" => client_order_id
          },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
        body >= expected_body
      end).to have_been_made
    end

    it "returns an order receipt" do
      stub_create_order
      order = client.create_market_sell_order("BTC_USDT", 100)
      expect(order.order_id).to be_a String
      expect(order.client_order_id).to be_a String
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.create_market_sell_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.create_market_sell_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.create_market_sell_order("BTC_USDT", 100)
      end.to raise_error CryptoClient::Errors::ServerError
    end
  end

  describe "get_account_summary" do
    let(:url) { %r{#{base_url}/private/get-account-summary} }

    it "makes a request to the expected URL" do
      stub_get_account_summary
      client.get_account_summary
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_get_account_summary
      client.get_account_summary("CRO")
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        body >= {
          method: "private/get-account-summary",
          params: { "currency" => "CRO" },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
      end).to have_been_made
    end

    it "returns an array of accounts" do
      stub_get_account_summary
      accounts = client.get_account_summary
      expect(accounts).to be_an Array
      accounts.each do |account|
        expect(account.balance).to be_a Float
        expect(account.available).to be_a Float
        expect(account.order).to be_a Float
        expect(account.stake).to be_a Float
        expect(account.currency).to be_a String
      end
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.get_account_summary
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.get_account_summary
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.get_account_summary
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.get_account_summary
      rescue StandardError
        # Ignore
      end
      expect(a_request(:post, url)).to have_been_made.times(4)
    end
  end

  describe "get_candlestick" do
    let(:url) { %r{#{base_url}/public/get-candlestick} }

    it "makes a request to the expected URL" do
      stub_get_candlestick
      client.get_candlestick("BTC_USDT", "5m")
      expect(a_request(:get, url)).to have_been_made
    end

    it "makes a request with the expected query values" do
      stub_get_candlestick
      client.get_candlestick("BTC_USDT", "5m")
      expect(a_request(:get, url).with do |req|
        query_values = req.uri.query_values.symbolize_keys
        query_values >= {
          instrument_name: "BTC_USDT",
          timeframe: "5m"
        }
      end).to have_been_made
    end

    it "returns an array of candlesticks" do
      stub_get_candlestick
      candlesticks = client.get_candlestick("BTC_USDT", "5m")
      expect(candlesticks).to be_an Array
      candlesticks.each do |candlestick|
        expect(candlestick.time).to be_a Time
        expect(candlestick.open).to be_a Float
        expect(candlestick.high).to be_a Float
        expect(candlestick.low).to be_a Float
        expect(candlestick.close).to be_a Float
        expect(candlestick.volume).to be_a Float
      end
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.get_candlestick("BTC_USDT", "5m")
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.get_candlestick("BTC_USDT", "5m")
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.get_candlestick("BTC_USDT", "5m")
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.get_candlestick("BTC_USDT", "5m")
      rescue StandardError
        # Ignore
      end
      expect(a_request(:get, url)).to have_been_made.times(4)
    end
  end

  describe "get_instruments" do
    let(:url) { %r{#{base_url}/public/get-instruments} }

    it "makes a request to the expected URL" do
      stub_get_instruments
      client.get_instruments
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns an array of candlesticks" do
      stub_get_instruments
      instruments = client.get_instruments
      expect(instruments).to be_an Array
      instruments.each do |instrument|
        expect(instrument.name).to be_a String
        expect(instrument.quote_currency).to be_a String
        expect(instrument.base_currency).to be_a String
        expect(instrument.price_decimals).to be_an Integer
        expect(instrument.quantity_decimals).to be_an Integer
        expect(instrument.margin_trading_enabled).to be_boolean
      end
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.get_instruments
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.get_instruments
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.get_instruments
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.get_instruments
      rescue StandardError
        # Ignore
      end
      expect(a_request(:get, url)).to have_been_made.times(4)
    end
  end

  describe "get_order_detail" do
    let(:url) { %r{#{base_url}/private/get-order-detail} }

    it "makes a request to the expected URL" do
      stub_get_order_detail
      client.get_order_detail("123")
      expect(a_request(:post, url)).to have_been_made
    end

    it "makes a request with the expected body" do
      stub_get_order_detail
      client.get_order_detail("123")
      expect(a_request(:post, url).with do |req|
        body = JSON.parse(req.body).symbolize_keys
        body >= {
          method: "private/get-order-detail",
          params: { "order_id" => "123" },
          id: id,
          nonce: nonce,
          sig: signature_for(body)
        }
      end).to have_been_made
    end

    it "returns an array of accounts" do
      stub_get_order_detail
      order = client.get_order_detail("123")
      expect(order.status).to be_a String
      expect(order.side).to be_a String
      expect(order.order_id).to be_a String
      expect(order.client_order_id).to be_a String
      expect(order.create_time).to be_a Time
      expect(order.update_time).to be_a Time
      expect(order.type).to be_a String
      expect(order.instrument_name).to be_a String
      expect(order.cumulative_quantity).to be_a Float
      expect(order.cumulative_value).to be_a Float
      expect(order.average_price).to be_a Float
      expect(order.fee_currency).to be_a String
      expect(order.time_in_force).to be_a String
      expect(order.exec_inst).to be_a String
    end

    it "raises a BadRequestError when the server returns a bad request error" do
      stub_bad_request_error
      expect do
        client.get_order_detail("123")
      end.to raise_error CryptoClient::Errors::BadRequestError
    end

    it "raises an UnauthorizedError when the server returns an unauthorized error" do
      stub_unauthorized_error
      expect do
        client.get_order_detail("123")
      end.to raise_error CryptoClient::Errors::UnauthorizedError
    end

    it "raises a ServerError when the server returns a server error" do
      stub_server_error
      expect do
        client.get_order_detail("123")
      end.to raise_error CryptoClient::Errors::ServerError
    end

    it "retries when the the request fails with a retriable error" do
      stub_server_error
      begin
        client.get_order_detail("123")
      rescue StandardError
        # Ignore
      end
      expect(a_request(:post, url)).to have_been_made.times(4)
    end
  end
end
