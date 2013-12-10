Forex::Trader.define "JNBS" do |t|
  t.base_currency = "JMD"
  t.name          = "Jamaica National Building Society"
  t.endpoint      = "http://www.jnbs.com/fx-rates-2"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 0,
      sell_cash: 4,
      buy_cash: 2,
      buy_draft: 1,
    }

    table = doc.css(".fx-full").first

    Forex::TabularRates.new(table, options).parse_rates
  end
end

