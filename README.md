# Fahrenheit2Celsius

Welcome to Fahrenheit2Celsius, or F2C for short. This program converts a single fahrenheit temperature to celsius, or optionally kelvin. It can also convert celsius and kelvin to any of the above three temperatures interchangeably. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'Fahrenheit2Celsius'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install Fahrenheit2Celsius

## Usage

To run F2C, simply pass a temperature to F2C via the command-line (fahrenheit is the default input temperature): `f2c 68`. This will output `20.0°C`. To convert between Celsius and Kelvin, run `f2c -ic -ok 20`. This will output `293.15K`.

A full list of the command line options can be found by running `f2c --help`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rmiesen/Fahrenheit2Celsius.

## License

The gem is available as open source under the terms of the [EPL 2.0 License](https://opensource.org/license/epl-2-0).
****