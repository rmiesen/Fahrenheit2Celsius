#!/usr/bin/env ruby

require "optparse-plus"
require_relative "../lib/Fahrenheit2Celsius"

include OptparsePlus::Main
include OptparsePlus::CLILogging

# TODO: Write command line program using logic tested in Fahrenheit2Celsius module


# cli options: -k, -c, -n -v <temperature>
# -[io]f: convert to fahrenheit (silly)
# -[io]k: convert to kelvin
# -[io]c: convert to celsius (redundant)
# -[io]: Designates input or output, respectively. Argument to option sets the value.
#   Example: -ik sets the input temperature to kelvin.
# -n: strip the unit designators, only output numbers
# -v: be verbose. Show the input temperature and output temperatures

# TODO: validate cli args against other possible units of temperature you might add later
# TODO: What about variable input and output temperature units?

main do
  puts options["input-scale"]
  puts options["output-scale"]

  pp options
end

arg :input_temperature, :required, :one

options["input-scale"] = :fahrenheit
options["output-scale"] = :celsius
scale_regex = /^(?:[fkc]|(?:fahrenheit|celsius|kelvin))$/i
scales = %w{ f[ahrenheit] c[elsius] k[elvin] }
on("-i", "--input-scale=VALUE", "Temperature scale used for input. Supported temperature scales: #{scales.join(" ")}", scale_regex) do |value|

  case value
  when /^f|fahrenheit$/i
    options["input-scale"] = :fahrenheit
  when /^c|celsius$/i
    options["input-scale"] = :celsius
  when /^k|kelvin$/i
    options["input-scale"] = :kelvin
  else
    raise ArgumentError, "Don't know how to handle: #{value}"
  end
end

on("-o", "--output-scale=VALUE", "Temperature scale used for output. Supported temperature scales: #{scales.join(" ")}", scale_regex) do |value|
  case value
  when /^f|fahrenheit$/i
    options["output-scale"] = :fahrenheit
  when /^c|celsius$/i
    options["output-scale"] = :celsius
  when /^k|kelvin$/i
    options["output-scale"] = :kelvin
  else
    raise ArgumentError, "Don't know how to handle: #{value}"
  end
end

on("-n", "--no-units", "Strip the unit designators, only output temperatures")
on("-v", "--verbose", "Be verbose")


go!