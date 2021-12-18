# frozen_string_literal: true

module CryptoClient
  module Util
    class ClientOrderIdGenerator
      def initialize(prefix)
        @prefix = prefix
      end

      def generate
        id = SecureRandom.uuid
        "#{@prefix}_#{id}"
      end
    end
  end
end
