Forex::Trader.define "JMMB" do |t|
  t.base_currency   = "JMD"
  t.name            = "Jamaica Money Market Brokers"
  t.twitter_handle  = "@JMMBGROUP"
  t.endpoint        = 'https://jm.jmmb.com/rates-fees'

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    options = {
      currency_code: 0,
      buy_cash: 1,
      buy_draft: 2,
      sell_cash: 3,
      sell_draft: 3
    }

    table =
      doc.search("[text()*='FX Rates']").first.  # Section with rates
       ancestors('div').first.                         # Root table for section
       css("table").first                                # Rates table

    Forex::TabularRates.new(table, options).parse_rates
  end
end
