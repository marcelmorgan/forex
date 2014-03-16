Forex::Trader.define "Sagicor" do |t|
  t.base_currency   = "JMD"
  t.name            = "Sagicor Bank"
  t.twitter_handle  = "@SagicorJa"
  t.endpoint        = "http://www.gopancaribbean.com/personal-banking"

  t.rates_parser = ->(doc) do # doc is a nokogiri document
    table = doc.css("table .data").first
    Forex::TabularRates.new(table).parse_rates
  end
end
