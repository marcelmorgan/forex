Forex::Trader.define "COK" do |t|
  t.base_currency = "JMD"
  t.name          = "City Of Kingston Credit Union"
  t.endpoint      = "http://www.cokcu.com/otherservices/cambio/"

  t.rates_parser = ->(doc) do # doc is a nokogiri document

    table = doc.css(".table-bordered").first

    translations = {
      'CI'    => 'KYD',
      'Euro'  => 'EUR',
    }

    Forex::TabularRates.new(table).parse_rates(translations)
  end
end
