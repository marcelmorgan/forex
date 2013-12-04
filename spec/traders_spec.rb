require 'spec_helper'

describe "Traders" do

  Trader.all.each do |short_name, trader|
    it short_name, :vcr do
      expect(trader.fetch).not_to be_empty
    end
  end
end
