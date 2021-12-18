# frozen_string_literal: true

require "crypto_client/credentials"

module CryptoClient
  module Operations
    class Config
      URL_BASE_UAT = "https://uat-api.3ona.co/v2/"
      URL_BASE_PROD = "https://api.crypto.com/v2/"

      attr_reader :url_base, :credentials

      def initialize(type)
        @url_base = if type == :UAT
                      URL_BASE_UAT
                    else
                      URL_BASE_PROD
                    end

        @credentials = Credentials.new
      end
    end
  end
end
