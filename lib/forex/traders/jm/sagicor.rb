Forex::Trader.define "Sagicore" do |t|
  t.base_currency = "JMD"
  t.name          = "Sagicore Bank"
  t.endpoint      = "http://www.gopancaribbean.com/personal-banking"

  t.rates_parser = ->(doc) do # doc is a nokogiri document
    table = doc.css("table .data").first
    Forex::TabularRates.new(table).parse_rates
  end
end
