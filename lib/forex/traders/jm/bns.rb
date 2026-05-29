Forex::Trader.all.delete("BNS")
Forex::Trader.define "BNS" do |t|
  t.base_currency   = "JMD"
  t.name            = "Bank of Nova Scotia"
  t.twitter_handle  = "@ScotiabankJM"
  t.endpoint        = "https://jm.scotiabank.com/personal/rates-and-fees/foreign-exchange-rates.html"
  t.rates_parser = ->(doc) do
    table = doc.css("table").first
    table.css("tr").each_with_object({}) do |tr, rates|
      tds = tr.css("td")
      next unless tds.size == 5
      code = tds[1].text.gsub(/[[:space:]]/, "").strip
      next unless code.length == 3 && code =~ /\A[A-Z]{3}\z/
      clean = ->(td) do
        val = td.text.gsub(/[^0-9.\-]/, "").to_f
        val == 0.0 ? nil : val
      end
      rates[code] = {
        buy_cash: clean.(tds[2]),
        buy_draft: clean.(tds[3]),
        sell_cash: clean.(tds[4]),
        sell_draft: clean.(tds[4]),
      }
    end
  end
end
