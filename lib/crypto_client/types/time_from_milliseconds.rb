module CryptoClient
  module Types
    class TimeFromMilliseconds
      def self.parse(data)
        seconds = data / 1000
        Time.at(seconds).utc
      end
    end
  end
end
