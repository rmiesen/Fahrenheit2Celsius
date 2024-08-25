# frozen_string_literal: true

require_relative '../lib/Fahrenheit2Celsius'



RSpec.describe Fahrenheit2Celsius do
  it "has a version number" do
    expect(Fahrenheit2Celsius::VERSION).not_to be nil
  end
end

module Fahrenheit2Celsius
  RSpec.describe Temperature do
     it "can new itself with a temperatures" do
       temp_f = 123.456
       temp = Fahrenheit2Celsius::Temperature.new temp_f
       expect temp.temperature == temp_f.round(2)
     end

     it "can get and set temperatures" do
       temp = Fahrenheit2Celsius::Temperature.new
       temp.temperature = 123.456
       expect temp.temperature == 123.45   ## Temperature has a precision of 2.
     end

     it "has a proper degree unicode symbol" do
       temp = Temperature.new
       temp_str = temp.to_s
       expect temp_str.include? "\u00B0"
     end

     # protected members can be tested by using an object's send method.
     # However, in this case I am electing to test Temperature.conversions indirectly
     # through its public interface: get_conversion().

     it "can represent the temperature as a string correctly" do
       expected_temp_f = 12.56
       expected_temp_str = "#{expected_temp_f}\u00B0"
       temp = Temperature.new
       temp.temperature = expected_temp_f
       temp_str = temp.to_s
       expect temp_str == expected_temp_str
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

    # TODO: Move @@conversions class variable to child classses, rely on implementations to sort out details, avoid clobbering of shared variable.
    it "can convert to Fahrenheit" do
      fahrenheit = kelvin.convert(:fahrenheit)
      expect(fahrenheit).to eq 68
    end
  end
end
