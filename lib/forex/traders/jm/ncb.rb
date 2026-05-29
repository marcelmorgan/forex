Forex::Trader.all.delete("NCB")
Forex::Trader.define "NCB" do |t|
  t.base_currency   = "JMD"
  t.name            = "National Commercial Bank"
  t.endpoint        = "https://www.jncb.com/"
  t.twitter_handle  = "@ncbja"
  t.rates_parser = ->(doc) do
    options = { currency_code: 0, sell_cash: 1, buy_draft: 2, buy_cash: 3 }
    table = doc.css("table").first
    Forex::TabularRates.new(table, options).parse_rates
  end
end
