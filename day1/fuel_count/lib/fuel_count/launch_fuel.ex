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
  def fuel_for_mass(mass) do
    floor(mass / 3) - 2
  end
end
