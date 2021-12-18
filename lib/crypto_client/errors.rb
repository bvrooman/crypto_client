# frozen_string_literal: true

module CryptoClient
  module Errors
    class ClientError < StandardError; end

    class APIError < ClientError
      attr_reader :status

      def initialize(status, msg = nil)
        @status = status
        super(msg)
      end
    end

    # 400
    class BadRequestError < APIError; end

    # 401
    class UnauthorizedError < APIError; end

    # 500
    class ServerError < APIError; end
  end
end
