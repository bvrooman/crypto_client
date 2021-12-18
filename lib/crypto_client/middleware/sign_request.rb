# frozen_string_literal: true

module CryptoClient
  module Middleware
    class SignRequest
      def inputs
        [:request]
      end

      def outputs
        [:signed_request]
      end

      attr_reader :credentials, :nonce_generator

      def initialize(credentials)
        @credentials = credentials
        @nonce_generator = Util::NonceGenerator.new
      end

      def call(_operation, context, *_args)
        request = context[:request]
        request.payload[:id] = request.id
        sign(request.payload)
      end

      def sign(payload)
        key = credentials.key
        secret = credentials.secret

        payload[:nonce] = generate_nonce
        payload[:api_key] = key

        signature = self.class.signature_for(payload, secret)
        payload[:sig] = signature
        payload
      end

      def generate_nonce
        nonce_generator.generate
      end

      def self.signature_for(payload, secret)
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
    end
  end
end
