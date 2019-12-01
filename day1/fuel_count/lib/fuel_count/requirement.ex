defmodule FuelCount.Requirement do
  @moduledoc """
  Calculate the fuel requirements based on module masses
  """

  @doc """
  Aggregate the complete fuel requirements for a ship based on the module masses captured in the provided file
  """
  def aggregate(module_mass_path) do
    File.stream!(module_mass_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(&FuelCount.LaunchFuel.fuel_for_mass/1)
    |> Enum.sum()
  end
end
