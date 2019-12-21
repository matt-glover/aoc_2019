defmodule Intcode.Program do
  @moduledoc false

  defstruct memory: %Intcode.Memory{}, instruction_pointer: 0
end
