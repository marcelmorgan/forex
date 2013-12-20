Given(/^the tabular rates table:$/) do |table|
  @table = Nokogiri::HTML(table)
end

When(/^the column options exist for the tabular rates parser:$/) do |options_table|
  @options = options_table.hashes.first
end

Then(/^parsing the table should return the following rates:$/) do |table|
  assert_rates_are_equal_to table
end

Then(/^parsing the table should raise an exception with the message:$/) do |table|
  message = table.raw.first.first
  expect { parse_rates }.to raise_error(message)
end

When(/^the currency translations:$/) do |table|
  @translations = table.raw.each_with_object({}) do |translation, h|
    key, value = translation
    h[key] = value
  end
end

module KnowsTabularRates
  include Forex

  def translations
    @translations || {}
  end

  def parse_rates
    TabularRates.new(@table, @options).parse_rates(translations)
  end

  def assert_rates_are_equal_to(table)
    table = table.dup # because we modify it below

    convert_rates! table

    formatted_rates = table.hashes.each_with_object({}) do |table_hash, currencies|
      table_hash.symbolize_keys!

      currencies[table_hash.delete(:currency_code)] =
        table_hash.each_with_object({}) do |currency_rate, rates|
          currency, rate = *currency_rate
          rates[currency] = rate
        end
    end

    parse_rates.should == formatted_rates
  end

  def convert_rates!(table)
    zero_to_nil = ->(value) { value == 0 ? nil : value }

    TabularRates::COLUMN_LABELS.each do |column_label|
      table.map_column!(column_label) { |value| zero_to_nil.(value.to_f) }
    end
  end
end

World(KnowsTabularRates)