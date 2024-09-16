#!/usr/bin/env ruby

require "optparse-plus"
require_relative "../lib/Fahrenheit2Celsius"

include OptparsePlus::Main
include OptparsePlus::CLILogging
include Fahrenheit2Celsius

# cli options: -k, -c, -n -v <temperature>
# -[io]f: convert to fahrenheit (silly)
# -[io]k: convert to kelvin
# -[io]c: convert to celsius (redundant)
# -[io]: Designates input or output, respectively. Argument to option sets the value.
#   Example: -ik sets the input temperature to kelvin.
# -n: strip the unit designators, only output numbers
# -v: be verbose. Show the input temperature and output temperatures

# TODO: validate cli args against other possible units of temperature you might add later

main do |input_temperature|
  i_temperature = case options["input-scale"]
  when :fahrenheit
    Fahrenheit.new input_temperature
  when :celsius
    Celsius.new input_temperature
  when :kelvin
    Kelvin.new input_temperature
  else
    raise ArgumentError "Don't know how to process the #{options["input-scale"]} input"
                  end

  converted_temp = i_temperature.convert options["output-scale"]

  # rubocop:disable Style/UnlessElse
  result = unless options[:no_units]
    o_temperature = case options["output-scale"]
                    when :fahrenheit
                      Fahrenheit.new converted_temp
                    when :celsius
                      Celsius.new converted_temp
                    when :kelvin
                      Kelvin.new converted_temp
                    else
                      raise ArgumentError "Don't know how to process the #{options["output-scale"]} output"

                    end
    o_temperature
  else
    converted_temp
  end
  # rubocop:enable Style/UnlessElse
  if options[:verbose]
    input = options[:no_units] ? input_temperature.to_f : i_temperature
    result = <<~END
    Input:  #{input}
    Output: #{result}
    END
  end

  puts result
  #TODO: When outputting the temperature, run in rescue block, catch the Encoding::UndefinedConversionError exception. If it happens, strip the degree symbol from the output and try again.
end

arg :input_temperature, :required, :one,
    "A temperature with up to two decimal places of precision that is to be converted (additional digits beyond the second will be ignored)"

options["input-scale"] = :fahrenheit
options["output-scale"] = :celsius
scale_regex = /^(?:[fkc]|(?:fahrenheit|celsius|kelvin))$/i
scales = %w{ f[ahrenheit] c[elsius] k[elvin] }
on("-i", "--input-scale=VALUE",
   "Temperature scale used for input. Supported temperature scales: #{scales.join(" ")}", scale_regex) do |value|

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

on("-o", "--output-scale=VALUE",
   "Temperature scale used for output. Supported temperature scales: #{scales.join(" ")}", scale_regex) do |value|
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

on("-n", "--no-units", "Strip the unit designators, only output temperatures") { options[:no_units] = true }

on("-v", "--verbose", "Be verbose") { options[:verbose] = true }


go!