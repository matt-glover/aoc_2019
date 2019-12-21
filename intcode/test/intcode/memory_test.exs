defmodule Intcode.MemoryTest do
  use ExUnit.Case
  alias Intcode.Memory

  test "new/1 loads a program into memory" do
    initialized = Memory.new("1,2,3,1,99")
    assert(Memory.read_memory(initialized, 0) == 1)
    assert(Memory.read_memory(initialized, 1) == 2)
    assert(Memory.read_memory(initialized, 2) == 3)
    assert(Memory.read_memory(initialized, 3) == 1)
    assert(Memory.read_memory(initialized, 4) == 99)
  end

  test "read_memory/2 returns the raw int at a memory location" do
    raw_memory = Memory.new("1,2,3,4,99")
    assert(Memory.read_memory(raw_memory, 0) == 1)
    assert(Memory.read_memory(raw_memory, 4) == 99)
  end

  test "read_instruction/2 returns the instruction at a memory location" do
    memory = Memory.new("1,2,3,4,99")

    assert(
      %Intcode.Instruction{op_code: :add, parameters: {3, 4, 4}} =
        Memory.read_instruction(memory, 0)
    )

    assert(%Intcode.Instruction{op_code: :halt} = Memory.read_instruction(memory, 4))
  end
end
