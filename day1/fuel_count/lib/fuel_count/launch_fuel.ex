defmodule FuelCount.LaunchFuel do
  @moduledoc """
  Figure out the amount of launch fuel required for a module
  """

  @doc """
  Convert a mass measure to a required fuel measurement to launch that mass

  ## Examples

    iex> FuelCount.LaunchFuel.fuel_for_mass(9)
    1

  """
  def fuel_for_mass(component_mass) do
    total_fuel_for_mass(0, calc_fuel(component_mass))
  end

  defp total_fuel_for_mass(current_total, fuel_mass) when fuel_mass < 1 do
    current_total
  end

  defp total_fuel_for_mass(current_total, fuel_mass) do
    fuel_total = calc_fuel(fuel_mass)
    total_fuel_for_mass(current_total + fuel_mass, fuel_total)
  end

  defp calc_fuel(value) do
    floor(value / 3) - 2
  end
end
