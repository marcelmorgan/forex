Forex::Trader.define "JNBS" do |t|
  t.base_currency   = "JMD"
  t.name            = 'JN Bank'
  t.twitter_handle  = "@JamaicaNational"
  t.endpoint        = 'https://www.jnbank.com/fx-rates/'

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      sell_cash: 4,
      buy_cash: 2,
      buy_draft: 1,
    }

    tbody = doc.css('#fx-big-table tbody').first

    Forex::TabularRates.new(tbody, options).parse_rates
  end
end
