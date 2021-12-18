# frozen_string_literal: true

module CryptoClient
  module Middleware
    class ParseJson
      def inputs
        [:response]
      end

      def outputs
        [:parsed_response]
      end

      def call(_operation, context, *_args)
        response = context[:response]
        json = JSON.parse(response.body).deep_symbolize_keys
        context[:parsed_response] = json
      end
    end
  end
end
