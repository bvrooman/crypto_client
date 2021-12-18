# frozen_string_literal: true

module CryptoClient
  module Util
    class NonceGenerator
      def generate
        Time.now.to_i * 1000
      end
    end
  end
end
