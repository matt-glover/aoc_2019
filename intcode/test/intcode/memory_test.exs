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

  test "dump/1 dumps all memory as if it were source code used to initialize memory" do
    memory = %Memory{
      map: %{0 => 1, 1 => 3, 2 => 2, 3 => 1, 4 => 2, 5 => 0, 6 => 95, 7 => 3, 8 => 99}
    }

    assert "1,3,2,1,2,0,95,3,99" == Memory.dump(memory)
  end
end
