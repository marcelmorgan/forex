Given(/^the tabular rates table:$/) do |table|
  @table = Nokogiri::HTML(table)
end

When(/^the column options exist for the tabular rates parser:$/) do |options_table|
  @options = options_table.hashes.first
end

Then(/^parsing the table should return the following rates:$/) do |table|
  ensure_rates_are_equal_to table
end

Then(/^parsing the table should raise an exception with the message:$/) do |table|
  message = table.raw.first.first
  expect { parse_rates }.to raise_error(message)
end

def parse_rates
  Forex::TabularRates.new(@table, @options).parse_rates
end

def ensure_rates_are_equal_to(table)
  formatted_rates = table.hashes.each_with_object({}) do |table_hash, currencies|
    table_hash.symbolize_keys!

    currencies[table_hash.delete(:currency_code)] =
      table_hash.each_with_object({}) do |currency_rate, rates|
        currency, rate = *currency_rate
        rates[currency] = rate.to_f
      end
  end

  parse_rates.should == formatted_rates
end