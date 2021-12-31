# frozen_string_literal: true

module CryptoClient
  module Test
    def bad_request_error_body
      "".to_json
    end

    def unauthorized_error_body
      "".to_json
    end

    def server_error_body
      "".to_json
    end

    def cancel_all_orders_body
      {
        "id": 12,
        "method": "private/cancel-all-order",
        "code": 0
      }.to_json
    end

    def cancel_order_body
      {
        "id": 11,
        "method": "private/cancel-order",
        "code": 0
      }.to_json
    end

    def get_account_summary_body
      {
        "id": 11,
        "method": "private/get-account-summary",
        "code": 0,
        "result": {
          "accounts": [
            {
              "balance": 99_999_999.905000000000000000,
              "available": 99_999_996.905000000000000000,
              "order": 3.000000000000000000,
              "stake": 0,
              "currency": "CRO"
            }
          ]
        }
      }.to_json
    end

    def get_candlestick_body
      {
        "code": 0,
        "method": "public/get-candlestick",
        "result": {
          "instrument_name": "BTC_USDT",
          "interval": "5m",
          "data": [
            { "t": 1_596_944_700_000, "o": 11_752.38, "h": 11_754.77, "l": 11_746.65, "c": 11_753.64, "v": 3.694583 },
            { "t": 1_596_945_000_000, "o": 11_753.63, "h": 11_754.77, "l": 11_739.83, "c": 11_746.17, "v": 2.073019 },
            { "t": 1_596_945_300_000, "o": 11_746.16, "h": 11_753.24, "l": 11_738.1, "c": 11_740.65, "v": 0.867247 }
          ]
        }
      }.to_json
    end

    def get_instruments_body
      {
        "id": 11,
        "method": "public/get-instruments",
        "code": 0,
        "result": {
          "instruments": [
            {
              "instrument_name": "BTC_USDT",
              "quote_currency": "BTC",
              "base_currency": "USDT",
              "price_decimals": 2,
              "quantity_decimals": 6,
              "margin_trading_enabled": true

            },
            {
              "instrument_name": "CRO_BTC",
              "quote_currency": "BTC",
              "base_currency": "CRO",
              "price_decimals": 8,
              "quantity_decimals": 2,
              "margin_trading_enabled": false
            }
          ]
        }
      }.to_json
    end

    def create_order_body
      {
        "id": 11,
        "method": "private/create-order",
        "result": {
          "order_id": "337843775021233500",
          "client_oid": "my_order_0002"
        }
      }.to_json
    end

    def get_order_detail_body
      {
        "id": 11,
        "method": "private/get-order-detail",
        "code": 0,
        "result": {
          "trade_list": [
            {
              "side": "BUY",
              "instrument_name": "ETH_CRO",
              "fee": 0.007,
              "trade_id": "371303044218155296",
              "create_time": 1_588_902_493_045,
              "traded_price": 7,
              "traded_quantity": 7,
              "fee_currency": "CRO",
              "order_id": "371302913889488619"
            }
          ],
          "order_info": {
            "status": "FILLED",
            "side": "BUY",
            "order_id": "371302913889488619",
            "client_oid": "9_yMYJDNEeqHxLqtD_2j3g",
            "create_time": 1_588_902_489_144,
            "update_time": 1_588_902_493_024,
            "type": "LIMIT",
            "instrument_name": "ETH_CRO",
            "cumulative_quantity": 7,
            "cumulative_value": 7,
            "avg_price": 7,
            "fee_currency": "CRO",
            "time_in_force": "GOOD_TILL_CANCEL",
            "exec_inst": "POST_ONLY"
          }
        }
      }.to_json
    end

    # RESPONSES

    def bad_request_error_response
      {
        status: 400,
        body: bad_request_error_body
      }
    end

    def unauthorized_error_response
      {
        status: 401,
        body: unauthorized_error_body
      }
    end

    def server_error_response
      {
        status: 500,
        body: server_error_body
      }
    end

    def cancel_all_orders_response
      {
        status: 200,
        body: cancel_all_orders_body
      }
    end

    def cancel_order_response
      {
        status: 200,
        body: cancel_order_body
      }
    end

    def get_account_summary_response
      {
        status: 200,
        body: get_account_summary_body
      }
    end

    def get_candlestick_response
      {
        status: 200,
        body: get_candlestick_body
      }
    end

    def get_instruments_response
      {
        status: 200,
        body: get_instruments_body
      }
    end

    def create_order_response
      {
        status: 200,
        body: create_order_body
      }
    end

    def get_order_detail_response
      {
        status: 200,
        body: get_order_detail_body
      }
    end
  end
end
