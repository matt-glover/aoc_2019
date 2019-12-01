defmodule FuelCount.LaunchFuelTest do
  use ExUnit.Case
  doctest FuelCount.LaunchFuel

  test "For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2" do
    assert(FuelCount.LaunchFuel.fuel_for_mass(12) == 2)
  end

  test "For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2" do
    assert(FuelCount.LaunchFuel.fuel_for_mass(14) == 2)
  end

  test "For a mass of 1969, the fuel required is 654" do
    assert(FuelCount.LaunchFuel.fuel_for_mass(1969) == 654)
  end

  test "For a mass of 100756, the fuel required is 33583" do
    assert(FuelCount.LaunchFuel.fuel_for_mass(100_756) == 33583)
  end
end
