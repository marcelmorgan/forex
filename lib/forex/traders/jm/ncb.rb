Forex::Trader.define "NCB" do |t|
  t.base_currency   = "JMD"
  t.name            = "National Commercial Bank"
  t.endpoint        = "https://www.jncb.com/Support/Help-Resources/Foreign-Exchange-Services"
  t.twitter_handle  = "@ncbja"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 0,
      sell_cash: 1,
      buy_cash: 3,
      buy_draft: 2,
    }

    tbody = doc.css("tbody.FxRContainer").first

    Forex::TabularRates.new(tbody, options).parse_rates
  end
end
