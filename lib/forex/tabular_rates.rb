module Forex
  class TabularRates
    NoSuchColumn = Class.new(StandardError)

    attr_accessor :table, :options

    COLUMN_LABELS = [
      :buy_cash,
      :buy_draft,
      :sell_cash,
      :sell_draft
    ]

    DEFAULT_OPTIONS = {
      currency_code: 0,
    }.merge(Hash[(COLUMN_LABELS).zip(1..COLUMN_LABELS.size)])

    def initialize(table, options = DEFAULT_OPTIONS)
      @table = table
      @options = options.symbolize_keys
    end

    def parse_rates(translations = {})
      currency = options.delete(:currency_code) || 0

      table.css('tr').each_with_object({}) do |tr, currencies|
        cells = tr.css('td')
        next if cells.empty?

        currency_code = CurrencyCode.new(cells[currency.to_i].content, translations)

        next if currencies.has_key?(currency_code.to_s) || currency_code.invalid?

        currencies[currency_code.to_s] = COLUMN_LABELS.each_with_object({}) do |column_label, rates|
          next unless rate_column = options[column_label]

          rate_node = cells[rate_column.to_i]
          raise NoSuchColumn, "#{column_label} (#{rate_column}) does not exist in table" unless rate_node

          rates[column_label.to_sym] = Currency.new(rate_node.content).value
        end
      end
    end

  end

  class Currency < Struct.new(:string)

    # converts the currency to it's storage representation
    def value
      converted == 0.0 ? nil : converted
    end

    private

    def converted
      @converted ||= string.strip.to_f
    end

  end

  class CurrencyCode < Struct.new(:string, :translations)

    # TODO validate the currency codes via http://www.xe.com/iso4217.php
    def valid?
      !translated.blank? && translated.length == 3
    end

    def invalid?
      !valid?
    end

    def to_s
      translated
    end

    private

    def translated
      @translated ||= translations[converted] || converted
    end

    def converted
      @converted ||= string.strip
    end
  end
end

