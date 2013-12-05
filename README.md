# Forex

Provides a simple DSL for managing Foreign Exchange rates (forex) for various
traders (Inspired by [CurrrencyJA](https://github.com/kenrick/currencyja)).

## Installation

Add this line to your application's Gemfile:

    gem 'forex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install forex

## Usage

To add a new trader, create a new file at
``lib/forex/traders/<country-code>/<trader-name>.rb`` with the following
contents:

```ruby

Forex::Trader.define "NCB" do |t|
  t.base_currency = "JMD"
  t.name          = "National Commercial Bank"
  t.endpoint      = "http://www.jncb.com/rates/foreignexchangerates"

  t.rates_parser = Proc.new do |doc| # doc is a nokogiri document
    # process the doc and return rates hash in the following format

    # {
    #   "USD" => {
    #     :buy_cash => 102.0,
    #     :buy_draft => 103.3,
    #     :sell_cash => 105.0
    #   },
    #   # ...
    # }
  end
end

# Rates may be fetched for a specific trader
Forex::Trader.all['BNS'].fetch

# Or all traders and yielded to the block given
Forex::Trader.fetch_all do |trader|
  # Save or do some other processing on the rates ``trader.rates`` hash.
end
```

### TabularRate

`TabularRate` allows you to simplify the process of parsing a table of rates.
Simply find the table and pass it along with options of what values are in which
columns (zero indexed).

For example:

```ruby
  #...

  t.rates_parser = Proc.new do |doc| # doc is a nokogiri document

    options = {
      currency_code: 1,
      sell_cash: 2,
      buy_cash: 4,
      buy_draft: 3,
    }

    table = doc.css(".rates table").first

    Forex::TabularRates.new(table, options).parse_rates
  end

  #...
```

## TODO

* Make it possible to have the same trader in multiple countries
* Add other traders in Jamaica

## Code Status

* [![Code Climate](https://codeclimate.com/github/mcmorgan/forex.png)](https://codeclimate.com/github/mcmorgan/forex)
* [![Build Status](https://api.travis-ci.org/mcmorgan/forex.png)](https://travis-ci.org/mcmorgan/forex)
* [![Dependency Status](https://gemnasium.com/mcmorgan/forex.png)](https://gemnasium.com/mcmorgan/forex)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
