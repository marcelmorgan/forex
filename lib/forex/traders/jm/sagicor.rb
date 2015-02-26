Forex::Trader.define "Sagicor" do |t|
  t.base_currency   = "JMD"
  t.name            = "Sagicor Bank"
  t.twitter_handle  = "@SagicorJa"
  t.endpoint        = "https://www.sagicorjamaica.com/personal/banking/fx-access"

  t.rates_parser = ->(doc) do # doc is a nokogiri document
    table = doc.css("table.table-condensed.table-hover").first
    Forex::TabularRates.new(table).parse_rates
  end
end
