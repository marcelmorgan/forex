module Forex
  class TabularRates
    NoSuchColumn = Class.new(StandardError)

    attr_accessor :table, :options

    DEFAULT_OPTIONS = {
      currency_code: 0,
      buy_cash: 1,
      buy_draft: 2,
      sell_cash: 3,
      sell_draft: 4,
    }

    def initialize(table, options = DEFAULT_OPTIONS)
      @table = table
      @options = options.symbolize_keys
    end

    def parse_rates
      currency = options.delete(:currency_code) || 0

      table.css('tr').each_with_object({}) do |tr, currencies|
        cells = tr.css('td')
        next if cells.empty?

        currency_code = CurrencyCode.new(cells[currency.to_i].content)

        next if currencies.has_key?(currency_code.to_s) || currency_code.invalid?

        currencies[currency_code.to_s] = column_labels.each_with_object({}) do |column_label, rates|
          next unless rate_column = options[column_label]

          rate_node = cells[rate_column.to_i]
          raise NoSuchColumn, "#{column_label} (#{rate_column}) does not exist in table" unless rate_node

          rates[column_label.to_sym] = Currency.new(rate_node.content).value
        end
      end
    end

    def column_labels
      [:buy_cash, :buy_draft, :sell_cash, :sell_draft]
    end

  end

  class Currency

    def initialize(string)
      @string = string
    end

    # converts the currency to it's storage representation
    def value
      value = @string.strip.to_f
      value == 0.0 ? nil : value
    end

  end

  class CurrencyCode
    def initialize(string)
      @string = string
    end

    # TODO validate the currency codes via http://www.xe.com/iso4217.php
    def valid?
      @string = to_s # hack
      !@string.blank? && @string.length == 3
    end

    def invalid?
      !valid?
    end

    def to_s
      @string.strip.
        # Replace currency symbols with letter equivalent
        # TODO go crazy and add the rest http://www.xe.com/symbols.php
        gsub('$', 'D').

        # Remove all non word charactes ([^A-Za-z0-9_])
        gsub(/\W/,'')

    end
  end
end

