require 'open-uri'

module Forex
  CannotRedefineTrader = Class.new(StandardError)

  class Trader
    attr_accessor :short_name,
                  :name,
                  :base_currency,
                  :endpoint,
                  :rates_parser,
                  :rates,
                  :twitter_handle

    class << self
      attr_accessor :all

      def define(short_name)
        raise CannotRedefineTrader, short_name if all[short_name]

        t = Forex::Trader.new(short_name)
        yield t if block_given?
        @all[short_name] = t
      end

      def reset
        @all = Hash.new
      end
    end

    def initialize(short_name)
      @short_name = short_name
    end

    def fetch
      @rates = rates_parser.(doc)
    end

    private

    # doc built from the endpoint
    def doc
      @doc ||= open(endpoint) { |f| Nokogiri::HTML(f.read) }
    end

    reset
  end
end
