# frozen_string_literal: true

module CryptoClient
  module Util
    class IdGenerator
      MAX_ID = 1 << 63

      def generate
        rand(MAX_ID)
      end
    end
  end
end
