Forex::Trader.define "JMMB" do |t|
  t.base_currency   = "JMD"
  t.name            = "Jamaica Money Market Brokers"
  t.twitter_handle  = "@JMMBGROUP"
  t.endpoint        = "http://www.jmmb.com/full_rates.php"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 0,
      buy_cash: 1,
      buy_draft: 3,
      sell_cash: 4,
      sell_draft: 4
    }

    translations = {
      'US$' => 'USD',
      'TT$' => 'TTD',
    }

    table =
      doc.search("[text()*='FX Trading Rates']").first.  # Section with rates
       ancestors('table').first.                         # Root table for section
       css("table").first                                # Rates table

    Forex::TabularRates.new(table, options).parse_rates(translations)
  end
end

