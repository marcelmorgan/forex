Forex::Trader.all.delete("FGB")
Forex::Trader.define "FGB" do |t|
  t.base_currency   = "JMD"
  t.name            = "First Global Bank"
  t.twitter_handle  = "@First_Global"
  t.endpoint        = "https://firstglobal-bank.com/personal-banking/foreign-exchange-rates/"
  t.rates_parser = ->(doc) do
    table = doc.css("table.table-bordered").first
    table.css("tr").each_with_object({}) do |tr, rates|
      th = tr.css("th").first
      tds = tr.css("td")
      next unless th && tds.size >= 3
      code = th.text.strip
      next unless code.length == 3
      rates[code] = {
        buy_cash: tds[0].text.strip.to_f,
        buy_draft: tds[1].text.strip.to_f,
        sell_cash: tds[2].text.strip.to_f,
        sell_draft: tds[2].text.strip.to_f,
      }
    end
  end
end
