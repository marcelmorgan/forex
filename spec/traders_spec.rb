require 'spec_helper'

describe "Traders" do

  Trader.all.each do |short_name, trader|
    it short_name, :vcr do
      trader.fetch

      expect(trader.rates).not_to be_empty
      expect(trader.rates).to be == expected_rates(short_name)
    end
  end

  def expected_rates(short_name)
    expected_rates_file_path = "spec/rates/#{short_name.downcase}.yml"

    unless File.exists?(expected_rates_file_path)
      pending "Create expected rates YAML for #{short_name} at #{expected_rates_file_path}"
    end

    YAML.load(File.read(expected_rates_file_path)). # read file
      each_with_object({}) do |(currency,txns), rates| # make txn type a symbol
        rates[currency] = txns.each_with_object({}) do |(txn, price), txn_price|
          txn_price[txn.to_sym] = price
        end
      end
  end

end
