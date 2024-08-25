# frozen_string_literal: true

require_relative "Fahrenheit2Celsius/version"

# TODO: Explore alternative implementations to OOP for this...OO in Ruby is quite painful, limiting.
module Fahrenheit2Celsius
  # Temperatures implemented. Used in conversion lookups
  :kelvin
  :celsius
  :fahrenheit

  class Error < StandardError; end
  # Your code goes here...

  # This is an abstract class for all types of Temperatures. Don't instance
  # directly.
  class Temperature
    protected
    @@conversions ||= { }
    # What should be suffixed to the printed temperature. Degree unicode
    # character: "\u00B0"
    @@degree_char = "\u00B0"
    

    public
    def initialize(temperature = 0.00)
      @temperature = temperature
    end

    # returns temperature with 2 digits of precision
    def temperature()
      return @temperature.round(2)
    end

    def temperature=(value)
      raise ArgumentError, "#{value} is not a Float" unless value.is_a? Float
      @temperature = value.round(2)
      #TODO: Abstract round(2) to a new attribute: precision
    end

    attr_reader :degree_char


    def get_conversion(temperatureType)
      @@conversions[self.class.name][temperatureType]
    end

    # Returns the temperature converted to the desired unit, as a float
    def convert(target_temperature = :kelvin)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def convert_temperature(source_temperature, target_temperature = :kelvin)
      target_temp = target_temperature.downcase
      if target_temperature.class.to_s.to_sym.downcase == target_temp
        return @temperature
      end

      unless @@conversions[source_temperature].key?(target_temp)
        raise ArgumentError, "There is no conversion specified for #{target_temperature}"
      end

      @@conversions[source_temperature][target_temp].call(@temperature)
    end


    def to_s()
      "#{temperature}#{degree_char}"
    end
  end


  class Kelvin < Temperature
    # This feels...unnatural. I want to put this in a static ctor like C#. But it works...
    @@conversions[:kelvin] = { }
    @@conversions[:kelvin][:celsius] = ->(temperature) { temperature - 273.15 }
    @@conversions[:kelvin][:fahrenheit] = ->(temperature) { @@conversions[:kelvin][:celsius].call(temperature) * 1.8 + 32 }
    # TODO: refactor degree char
    @@degree_char = 'K'

    def convert(target_temperature = :kelvin)
      convert_temperature(:kelvin, target_temperature)
    end
  end

  
  class Celsius < Temperature
    @@conversions[:celsius] = { }
    @@conversions[:celsius][:kelvin] = ->(temperature) { temperature + 273.15 }
    @@conversions[:celsius][:fahrenheit] = ->(temperature) { temperature * 1.8 + 32 }
    # @@degree_char += 'C'
  end


  class Fahrenheit < Temperature
    @@conversions[:fahrenheit] = { }
    @@conversions[:fahrenheit][:celsius] = ->(temperature) { (temperature - 32) / 1.8 }
    @@conversions[:fahrenheit][:kelvin] = ->(temperature) { @@conversions[:fahrenheit][:celsius].call(temperature) - 273.15 }
    # @@degree_char += 'F'
  end
end
