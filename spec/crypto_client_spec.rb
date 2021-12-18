# frozen_string_literal: true

RSpec.describe CryptoClient do
  it "has a version number" do
    expect(CryptoClient::VERSION).not_to be nil
  end
end
