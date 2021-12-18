# frozen_string_literal: true

module CryptoClient
  module Util
    class PublicOperation < BaseOperation
      self.http_method = :get
    end
  end
end
