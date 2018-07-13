require 'nokogiri'
require 'active_support/core_ext/string'

require "forex/version"
require "forex/tabular_rates"
require "forex/trader"

# Traders are automatically loaded
traders_path = File.join(File.dirname(__FILE__), 'forex', 'traders', '**', '*.rb')
Dir[traders_path].each { |file| require file }
