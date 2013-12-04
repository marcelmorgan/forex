Forex::Trader.define "BNS" do |t|
  t.base_currency = "JMD"
  t.name          = "Bank of Nova Scotia"
  t.endpoint      = "http://www4.scotiabank.com/cgi-bin/ratesTool/depdisplay.cgi?pid=56"

  t.rates_parser = Proc.new do |doc| # doc is a nokogiri document

    options = {
      currency_code: 0,
      buy_cash: 1,
      buy_draft: 2,
      sell_cash: 3,
      sell_draft: 3, # yes, it's the same rate
    }

    table = doc.css("table").first

    Forex::TabularRates.new(table, options).parse_rates
  end
end
