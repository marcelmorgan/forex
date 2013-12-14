Forex::Trader.define "COK" do |t|
  t.base_currency = "JMD"
  t.name          = "City Of Kingston Credit Union"
  t.endpoint      = "http://www.cokcu.com/otherservices/cambio/"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 0,
      buy_cash: 3,
      buy_draft: 2,
      sell_cash: 1,
    }

    table = doc.css(".table-bordered").first

    Forex::TabularRates.new(table, options).parse_rates
  end
end
