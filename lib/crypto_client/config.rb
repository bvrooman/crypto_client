# frozen_string_literal: true

require "logger"

require "crypto_client"

require "modelix/schema_loader"

module CryptoClient
  class Config
    @default_config = {
      api_key: "",
      api_secret: "",
      logger: Logger.new($stdout),
      modelix_path: CryptoClient::SCHEMAS_DIR
    }
    @allowed_config_keys = @default_config.keys

    class << self
      attr_reader :default_config, :allowed_config_keys
    end

    attr_reader :config

    def initialize
      @config = OpenStruct.new(Config.default_config)

      loader = Modelix::SchemaLoader.new
      loader.load_schema_path(config.modelix_path)
    end

    def configure(options)
      options.each do |key, value|
        @config.send("#{key.to_sym}=", value) if Config.allowed_config_keys.include? key.to_sym
      end
    end
  end

  def self.config
    @config ||= default_configuration
  end

  def self.default_configuration
    @default_configuration || Config.new.config
  end
end
