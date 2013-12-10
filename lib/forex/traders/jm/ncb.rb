Forex::Trader.define "NCB" do |t|
  t.base_currency = "JMD"
  t.name          = "National Commercial Bank"
  t.endpoint      = "http://www.jncb.com/rates/foreignexchangerates"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 1,
      sell_cash: 2,
      buy_cash: 4,
      buy_draft: 3,
    }

    table = doc.css(".rates table").first

    Forex::TabularRates.new(table, options).parse_rates
  end
end
