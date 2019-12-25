defmodule Intcode.Program do
  @moduledoc false

  defstruct memory: %Intcode.Memory{}, instruction_pointer: 0

  def new(source_code, instruction_pointer \\ 0) do
    %Intcode.Program{
      memory: Intcode.Memory.new(source_code),
      instruction_pointer: instruction_pointer
    }
  end
end
