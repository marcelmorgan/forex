require 'spec_helper'

describe "Traders" do

  Trader.all.each do |short_name, trader|
    it short_name, :vcr do
      trader.fetch

      expect(trader.rates).not_to be_empty
      expect(trader.rates).to eq(expected_rates(short_name))
    end
  end

  def expected_rates(short_name)
    expected_rates_file_path = "spec/rates/#{short_name.downcase}.yml"

    unless File.exists?(expected_rates_file_path)
      error_message = "Create expected rates YAML for #{short_name} at #{expected_rates_file_path}"
      raise error_message
    end

    expected_rates_yaml = File.read(expected_rates_file_path)
    expected_rates = YAML.load(expected_rates_yaml)

    expected_rates.each_with_object({}) do |(currency,txns), rates|
      rates[currency] = txns.each_with_object({}) do |(txn, price), txn_price|
        txn_price[txn.to_sym] = price
      end
    end
  end

end
