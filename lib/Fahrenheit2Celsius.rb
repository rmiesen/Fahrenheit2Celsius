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

    # logic for setter because Ruby's too dumb to call setters from initializers
    def set_temperature(value)
      new_temperature = value
      if value.is_a? Integer
        new_temperature = value.to_f
      end
      raise ArgumentError, "#{new_temperature} is not a Float" unless new_temperature.is_a? Float
      @temperature = new_temperature.round(2)
      #TODO: Abstract round(2) to a new attribute: precision
    end
    

    public
    def initialize(temperature = 0.00)
      @temperature = 0.00
      self.set_temperature(temperature)
    end

    # returns temperature with 2 digits of precision
    def temperature()
      return @temperature.round(2)
    end

    def temperature=(value)
      self.set_temperature(value)
    end

    attr_reader :degree_char


    def get_conversion(sourceTemperature, targetTemperature)
      @@conversions[sourceTemperature][targetTemperature]
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
      "#{temperature}#{@@degree_char}"
    end
  end


  class Kelvin < Temperature
    # This feels...unnatural. I want to put this in a static ctor like C#. But it works...
    @@conversions[:kelvin] = { }
    @@conversions[:kelvin][:kelvin] = ->(temperature) { temperature }
    @@conversions[:kelvin][:celsius] = ->(temperature) { (temperature - 273.15).round(2) }
    @@conversions[:kelvin][:fahrenheit] = ->(temperature) { (@@conversions[:kelvin][:celsius].call(temperature) * 1.8 + 32).round(2) }


    def temperature=(value)
      raise RangeError, "#{value} is less than 0" if value < 0
      super.temperature = value
    end
    def convert(target_temperature = :kelvin)
      convert_temperature(:kelvin, target_temperature)
    end

    # Not ideal, but  I'm tired of fighting Ruby's tortured OO implementation.
    def to_s()
      "#{temperature}K"
    end
  end


  class Celsius < Temperature
    @@conversions[:celsius] = { }
    @@conversions[:celsius][:celsius] = ->(temperature) { temperature }
    @@conversions[:celsius][:kelvin] = ->(temperature) { (temperature + 273.15).round(2) }
    @@conversions[:celsius][:fahrenheit] = ->(temperature) { (temperature * 1.8 + 32).round(2) }

    def convert(target_temperature = :kelvin)
      convert_temperature(:celsius, target_temperature)
    end

    def temperature=(value)
      raise RangeError, "#{value} is less than -273.15" if value < -273.15
      super.temperature = value
    end

    # Not ideal, but  I'm tired of fighting Ruby's tortured OO implementation.
    def to_s()
      "#{temperature}#{@@degree_char}C"
    end
  end


  class Fahrenheit < Temperature
    @@conversions[:fahrenheit] = { }
    @@conversions[:fahrenheit][:fahrenheit] = ->(temperature) { temperature }
    @@conversions[:fahrenheit][:celsius] = ->(temperature) { ((temperature - 32) / 1.8).round(2) }
    @@conversions[:fahrenheit][:kelvin] = ->(temperature) { (@@conversions[:fahrenheit][:celsius].call(temperature) + 273.15).round(2) }

    def convert(target_temperature = :kelvin)
      convert_temperature(:fahrenheit, target_temperature)
    end

    def temperature=(value)
      raise RangeError, "#{value} is less than -459.67" if value < -459.67
      super.temperature = value
    end
    # Not ideal, but  I'm tired of fighting Ruby's tortured OO implementation.
    def to_s()
      "#{temperature}#{@@degree_char}F"
    end
  end
end
