# frozen_string_literal: true

require_relative "base_operation"
require_relative "nonce_generator"

require "crypto_client/middleware/sign_request"

module CryptoClient
  module Util
    class PrivateOperation < BaseOperation
      self.http_method = :post

      def initialize(config, operation)
        super(config, operation)

        # Tell the executor to require the signer's outputs before executing
        signer = Middleware::SignRequest.new(config.credentials)
        add_middleware(signer)
        executor.inputs.push(*signer.outputs)
      end
    end
  end
end
