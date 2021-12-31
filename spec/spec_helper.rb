# frozen_string_literal: true

require "webmock/rspec"

require "crypto_client"
require "crypto_client/test"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include CryptoClient::Test
end

RSpec::Matchers.define :be_boolean do
  match do |actual|
    expect(actual).to be_in([true, false])
  end
end
