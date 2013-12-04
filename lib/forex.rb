require 'nokogiri'
require 'net/http'
require 'active_support/core_ext/string'

require "forex/version"
require "forex/tabular_rates"
require "forex/trader"

# Traders are automatically loaded
Dir[File.dirname(__FILE__) + '/forex/traders/**/*.rb'].each { |t| require t }
