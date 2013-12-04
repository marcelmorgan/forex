require 'spec_helper'

include Forex # so we don't need to prefix

describe Trader do
  before { Trader.reset }

  describe "#define" do
    specify { expect { |b| Trader.define("TRADER", &b) }.to yield_with_args(Forex::Trader) }

    it "includes the trader in #all" do
      trader = Trader.define("TRADER_IN_ALL")

      trader_in_all = Trader.all["TRADER_IN_ALL"]
      expect(trader_in_all).not_to be_nil
      expect(trader_in_all).to be == trader
    end

    it "prevents redefining the same trader" do
      Trader.define("TRADER_DUPLICATED")

      expect { Trader.define("TRADER_DUPLICATED") }.to raise_error(CannotRedefineTrader)
    end

    context "has all the properties set on definition" do
      let(:sample_rates) {
        {
          "USD" => { :buy_cash => 102.0, :buy_draft => 103.3, :sell_cash => 105.0 },
          "GBP" => { :buy_cash => 155.0, :buy_draft => 143.3, :sell_cash => 199.0 },
        }
      }
      let(:rates_parser) { ->(doc) { sample_rates } }

      let(:trader) {
        Forex::Trader.define "TRADER_X" do |t|
          t.base_currency = "JMD"
          t.name          = "Trader Named X"
          t.endpoint      = "http://www.example.com"
          t.rates_parser  = rates_parser
        end
      }

      specify { expect(trader.short_name).to be == "TRADER_X" }
      specify { expect(trader.base_currency).to be == "JMD" }
      specify { expect(trader.name).to be == "Trader Named X" }
      specify { expect(trader.endpoint).to be == "http://www.example.com" }
      specify { expect(trader.rates_parser).to be == rates_parser }

      it ".fetch" do
        trader.stub(:doc)
        expect(trader.fetch).to be == sample_rates
      end
    end
  end

end