# frozen_string_literal: true

require_relative '../../lib/Fahrenheit2Celsius'
require 'spec_helper'


# TODO: Refactor RSpecs to use before, let clauses to remove repetitive code
# BUG: Validate temperatures as being >= absolute zero

RSpec.describe Fahrenheit2Celsius do
  it "has a version number" do
    expect(Fahrenheit2Celsius::VERSION).not_to be nil
  end
end

module Fahrenheit2Celsius
  #BUG: Add new tests to all classes to check forced conversion of int to float
  RSpec.describe Temperature do
     it "can new itself with a temperatures" do
       temp_f = 123.456
       temp = Fahrenheit2Celsius::Temperature.new temp_f
       expect(temp.temperature).to eq temp_f.round(2)
     end

     it "can get and set temperatures" do
       temp = Fahrenheit2Celsius::Temperature.new
       temp.temperature = 123.456
       ## Temperature has a precision of 2, rounded to the nearest 100th of a degree
       expect(temp.temperature).to eq(123.46)
     end

     it "has a proper degree unicode symbol" do
       temp = Temperature.new
       temp_str = temp.to_s
       expect temp_str.include? "\u00B0"
     end

     # protected members can be tested by using an object's send method.
     # However, in this case I am electing to test Temperature.conversions indirectly
     # through its public interface: get_conversion().
     # Method is tested with the Kelvin class

     it "can represent the temperature as a string correctly" do
       expected_temp_f = 12.56
       expected_temp_str = "#{expected_temp_f}\u00B0"
       temp = Temperature.new
       temp.temperature = expected_temp_f
       temp_str = temp.to_s

       expect(temp_str).to eq expected_temp_str
     end

     it "will not permit the creation of non-numerical temperatures" do
       bad_temp = "dog"
       bad_temp_caught = false
       begin
         temp = Temperature.new bad_temp
       rescue ArgumentError => e
         bad_temp = bad_temp_caught = true
       end

       expect(bad_temp_caught).to be true
     end

     it "will still permit the creation of temperatures of 0.0" do
       good_temp = "0.0"
       good_temp_caught = false
       begin
         temp = Temperature.new good_temp
       rescue ArgumentError => e
         good_temp = good_temp_caught = true
       end

       expect(good_temp_caught).to be false

     end
     # Temperature.convert will be tested indirectly through the three temperature classes.
  end

  RSpec.describe Kelvin do
    kelvin = Fahrenheit2Celsius::Kelvin.new 293.15
    it "can convert to Celsius" do
      # so Temperature.convert takes a Temperature object and returns...a float?!
      # Is that really the best behavior? Yes, it is.
      celsius = kelvin.convert(:celsius)
      expect(celsius).to eq 20
    end

    it "can convert to Fahrenheit" do
      fahrenheit = kelvin.convert(:fahrenheit)
      expect(fahrenheit).to eq 68
    end

    it "can convert to Kelvin" do
      kelvin_2 = kelvin.convert(:kelvin)
      expect(kelvin_2).to eq kelvin.temperature
    end

    it "cannot set temperatures below absolute zero" do
      did_range_error_occur = false
      begin
        Kelvin.new(-1)
        test_kelvin = Kelvin.new 1
        test_kelvin.temperature = -1
      rescue RangeError
        did_range_error_occur = true
      end

      expect(did_range_error_occur).to eq true

    end

    it "can print Kelvin temperatures" do
      kelvin_txt = kelvin.to_s
      expect(kelvin_txt).to eq "#{kelvin.temperature}K"
    end

    it "can retrieve a conversion" do
      conv_func = kelvin.get_conversion :kelvin, :celsius
      expect(conv_func).to be_a Proc
    end
  end

  RSpec.describe Celsius do
    celsius = Fahrenheit2Celsius::Celsius.new 20
    it "can convert to Fahrenheit" do
      fahrenheit = celsius.convert(:fahrenheit)
      expect(fahrenheit).to eq 68
    end

    it "can convert to Kelvin" do
      kelvin = celsius.convert(:kelvin)
      expect(kelvin).to eq 293.15
    end

    it "can convert to Celsius" do
      celsius2 = celsius.convert(:celsius)
      expect(celsius2).to eq 20
    end

    it "cannot set temperatures below absolute zero" do
      did_range_error_occur = false
      begin
        Celsius.new(-274)
        test_celsius = Celsius.new(-272)
        test_celsius.temperature = -274
      rescue RangeError
        did_range_error_occur = true
      end

      expect(did_range_error_occur).to eq true
    end

    it "can print Celsius temperatures" do
      celsius_txt = celsius.to_s
      expect(celsius_txt).to eq "#{celsius.temperature}\u00B0C"
    end
  end

  RSpec.describe Fahrenheit do
    fahrenheit = Fahrenheit2Celsius::Fahrenheit.new 68
    it "can convert to Fahrenheit" do
      fahrenheit2 = fahrenheit.convert(:fahrenheit)
      expect(fahrenheit2).to eq 68
    end

    it "can convert to Kelvin" do
      kelvin = fahrenheit.convert(:kelvin)
      expect(kelvin).to eq 293.15
    end

    it "can convert to Celsius" do
      celsius = fahrenheit.convert(:celsius)
      expect(celsius).to eq 20
    end

    it "cannot set temperatures below absolute zero" do
      did_range_error_occur = false
      begin
        Fahrenheit.new(-460)
        test_celsius = Fahrenheit.new(-459)
        test_celsius.temperature = -460
      rescue RangeError
        did_range_error_occur = true
      end

      expect(did_range_error_occur).to eq true
    end

    it "can print Fahrenheit temperatures" do
      fahrenheit_txt = fahrenheit.to_s
      expect(fahrenheit_txt).to eq "#{fahrenheit.temperature}\u00B0F"
    end
  end
end
