# frozen_string_literal: true

require 'aruba/rspec'
require 'spec_helper'
require_relative '../../lib/Fahrenheit2Celsius'

# test cases:
# -i{fkc}, --input-scale={fahrenheit, celsius, kelvin}
# -o{fkc}, --output-scale={fahrenheit, celsius, kelvin}
#   -- Should mirror that of -i
# -n: use a context to group different output scales (we're testing all three outputs because of CLI)?
# -v
#
# argument: input_temperature, must be float compatible

#TODO: Figure out how to test case where terminal cannot output unicode and -n is not used
#   - Set the encoding of the "output stream" to ASCII, check for output sans the degree symbol

RSpec.describe "F2C's CLI interface", :type => :aruba do
  let(:f2c) { "f2c" }
  let(:degree_char) { "\u00B0" }
  let(:f_room_temp) { 68 }

  def simple_f2c_invocation optional_args=""
    "#{f2c} #{optional_args} #{f_room_temp}"
  end

  def f2c_invocation optional_args, temperature
    "#{f2c} #{optional_args} #{temperature}"
  end


  context "input" do
    it "expects fahrenheit" do
      run_command(f2c_invocation("-if", f_room_temp))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "expects fahrenheit, longhand" do
      run_command(f2c_invocation("--input-scale=FaHrEnHeIt", 68))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "expects celsius" do
      run_command(f2c_invocation("-ic", 20))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "expects celsius, longhand" do
      run_command(f2c_invocation("--input-scale=CeLsIuS", 20))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "expects kelvin" do
      run_command(f2c_invocation("-ik", 293.15))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "expects kelvin, longhand" do
      run_command(f2c_invocation("--input-scale=KeLvIn", 293.15))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end
  end

  context "output" do
    #when writing these tests, it will suffice to check the output symbol
    it "is in fahrenheit" do
      run_command(simple_f2c_invocation("-of"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/68.0/)
    end

    it "is in fahrenheit, longhand" do
      run_command(simple_f2c_invocation("--output-scale=fAhReNhEiT"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/68.0/)
    end

    it "is in celsius" do
      run_command(simple_f2c_invocation("-oc"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "is in celsius, longhand" do
      run_command(simple_f2c_invocation("--output-scale=cElSiUs"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/20.0/)
    end

    it "is in kelvin" do
      run_command(simple_f2c_invocation("-ok"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/293.15/)
    end

    it "is in kelvin, longhand" do
      run_command(simple_f2c_invocation("--output-scale=kElViN"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/293.15/)
    end
  end

  context "when a user wants unit designators" do
    it "outputs the result with unit designators" do
      run_command(simple_f2c_invocation)
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/#{degree_char}C$/)
    end
  end

  context "when a user just wants the raw converted numbers" do
    it "outputs the result without the unit designators" do
      run_command(simple_f2c_invocation("-n"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/^[0-9\.]+$/)
    end
  end

  context "when a user requests verbose output" do
    it "outputs the input on one line and the output on the second line" do
      run_command(simple_f2c_invocation("-v"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output <<~END.chomp!
        Input:  #{f_room_temp.to_f}#{degree_char}F
        Output: 20.0#{degree_char}C
      END
    end
  end

  context "when a user requests both verbose and just the raw converted numbers" do
    it "outputs the input on one line and the output on the second line without the unit designators" do
      run_command(simple_f2c_invocation("-v -n"))
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output <<~END.chomp!
        Input:  #{f_room_temp.to_f}
        Output: 20.0
      END

    end
  end
end