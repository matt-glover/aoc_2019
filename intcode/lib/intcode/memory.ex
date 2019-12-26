defmodule Intcode.Memory do
  @moduledoc false
  defstruct map: %{}

  def new(source_code) do
    parsed =
      String.split(source_code, ",")
      |> Enum.map(fn x -> String.to_integer(x) end)

    memory_map =
      parsed
      |> Stream.with_index()
      |> Map.new(fn {value, index} -> {index, value} end)

    %Intcode.Memory{map: memory_map}
  end

  def read_memory(memory, address) do
    memory.map[address]
  end

  def write_memory(memory, address, value) do
    updated = Map.put(memory.map, address, value)
    %{memory | map: updated}
  end

  @doc """
  Dump out the underlying memory data in the supported source code import format
  """
  def dump(memory) do
    Enum.map_join(memory.map, ",", fn {_key, value} -> value end)
  end
end
