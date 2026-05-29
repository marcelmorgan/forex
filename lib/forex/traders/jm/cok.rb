Forex::Trader.all.delete("COK")
Forex::Trader.define "COK" do |t|
  t.base_currency = "JMD"
  t.name          = "City Of Kingston Credit Union"
  t.endpoint      = "http://www.cokcu.com/otherservices/cambio/"
  t.rates_parser = ->(doc) do
    table = doc.css("table").first
    rows = table.css("tr")
    header_row = rows[0]
    headers = header_row.css("td,th").map(&:text).map(&:strip)
    currency_map = { "US ($)" => "USD", "UK(£)" => "GBP", "CDN ($)" => "CDN" }
    buying_row = rows.detect { |r| r.text.include?("Buying") }
    selling_row = rows.detect { |r| r.text.include?("Selling") }
    currencies = {}
    headers.each_with_index do |header, i|
      code = currency_map[header]
      next unless code
      buy_val = buying_row ? buying_row.css("td,th")[i]&.text&.strip&.to_f : nil
      sell_val = selling_row ? selling_row.css("td,th")[i]&.text&.strip&.to_f : nil
      buy_val = nil if buy_val == 0.0
      sell_val = nil if sell_val == 0.0
      currencies[code] = { buy_cash: buy_val, sell_cash: sell_val }
    end
    currencies
  end
end
