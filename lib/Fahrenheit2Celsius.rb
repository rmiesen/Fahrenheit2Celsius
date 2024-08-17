# frozen_string_literal: true

require_relative "Fahrenheit2Celsius/version"

module Fahrenheit2Celsius
  class Error < StandardError; end
  # Your code goes here...

  # This is an abstract class for all types of Temperatures. Don't instance
  # directly.
  class Temperature
    # protected Hash Conversions { get; set }
    protected
    @@conversions = Hash.new
    # What should be suffixed to the printed temperature. Degree unicode
    # character: "\u00B0"
    @@degree_char = "\u00B0"
    @temperature
    

    public
    def new(temperature)
      this.temperature = temperature
    end

    # returns temperature with 2 digits of precision
    def temperature()
      return @temperature.round(2)
    end

    def temperature=(value)
      raise ArgumentError, "#{value} is not a Float" unless value.is_a(Float)
      @temperature = value.round(2)
      #TODO: Abstract round(2) to a new attribute: precision
    end

    attr_reader :degree_char


    def self.get_conversion(temperatureType)
      @@conversions[temperatureType]
    end

    def convert(target_temperature: :kelvin)
      target_temp = target_temperature.downcase()
      if target_temperature.class.to_s.to_sym.downcase == target_temp
        return @temperature
      end
      
      raise ArgumentError, "There is no conversion specified for #{target_temperature}" unless @@conversions.has_key(target_temp)
      return @@conversions[target_temp].call(@temperature)
    end

    def to_s()
      puts "#{temperature}#{degree_char}"
    end
  end


  class Kelvin < Temperature
    def self.new()
      @@conversions[:celsius] = ->(temperature) { temperature + 273.15 }
      @@conversions[:fahrenheit] = ->(temperature) { @@conversions[:Celsius].call(temperature) * 1.8 + 32 }
      @@degree_char = 'K'
    end

  end

  
  class Celsius < Temperature
    def self.new()
      @@conversions[:kelvin] = ->(temperature) { temperature - 273.15 }
      @@conversions[:fahrenheit] = ->(temperature) { temperature * 1.8 + 32 }
      @@degree_char += 'C'
    end
  end


  class Fahrenheit < Temperature
    def self.new()
      @@conversions[:celsius] = ->(temperature) { (temperature - 32) / 1.8 }
      @@conversions[:kelvin] = ->(temperature) { @@conversions[:Celsius].call(temperature) - 273.15 }
      @@degree_char += 'F'
    end
  end
end
