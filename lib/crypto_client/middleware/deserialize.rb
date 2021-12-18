# frozen_string_literal: true

module CryptoClient
  module Middleware
    class Deserialize
      attr_reader :schema

      def initialize(schema)
        @schema = schema
      end

      def inputs
        [:parsed_response]
      end

      def outputs
        [:deserialized_response]
      end

      def call(_operation, context, *_args)
        response = context[:parsed_response]
        deserialized = schema.parse(response)
        context[:deserialized_response] = deserialized
        deserialized
      end
    end
  end
end
