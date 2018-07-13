module Forex
  class TabularRates
    NoSuchColumn = Class.new(StandardError)

    attr_accessor :table, :columns

    COLUMN_LABELS = [
      :buy_cash,
      :buy_draft,
      :sell_cash,
      :sell_draft
    ]

    DEFAULT_COLUMNS = {
      currency_code: 0,
    }.merge(Hash[(COLUMN_LABELS).zip(1..COLUMN_LABELS.size)])

    def initialize(table, columns = DEFAULT_COLUMNS)
      @table = table
      @columns = columns.symbolize_keys
    end

    def parse_rates(translations = {})
      table.css('tr').each_with_object(cached_currencies) do |tr, currencies|
        table_row = tr.css('td')

        next unless (currency_code = parse_currency_code(table_row, translations))

        currencies[currency_code] = COLUMN_LABELS.each_with_object({}) do |column_label, rates|
          rates.merge! parse_currency_rates(table_row, column_label)
        end
      end
    end

    private

    def cached_currencies
      @cached_currencies ||= {}
    end

    def currency_column
      @currency_column ||= columns.delete(:currency_code) || 0
    end

    def parse_currency_code(table_row, translations)
      return if table_row.empty?

      content = table_row[currency_column.to_i].content.gsub(/\A[[:space:]]*(.*?)[[:space:]]*\z/) { $1 }
      currency_code = CurrencyCode.new(content, translations)
      return if currency_code.invalid? ||
        cached_currencies.has_key?(parsed_currency_string = currency_code.to_s)

      parsed_currency_string
    end

    def parse_currency_rates(table_row, column_label)
      return {} unless rate_column = columns[column_label]

      rate_node = table_row[rate_column.to_i]

      raise NoSuchColumn, "#{column_label} (#{rate_column}) does not exist in table" unless rate_node

      { column_label.to_sym => Currency.new(rate_node.content).value }
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
