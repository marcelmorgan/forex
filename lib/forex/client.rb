require 'net/http'

module Forex

  class Client
    def get_response(endpoint)
      Net::HTTP.get_response(URI(endpoint)).tap do |response|
        raise "Received #{response.class} from #{endpoint}" unless response.is_a?(Net::HTTPSuccess)
      end
    end
  end

end
