defmodule Intcode.ParserTest do
  use ExUnit.Case
  alias Intcode.Parser
  alias Intcode.Instruction

  test "parse_instruction/2 builds the instruction at a memory location" do
    memory = Intcode.Memory.new("1,2,3,4,99")

    assert(
      %Instruction{op_code: :add, parameters: {3, 4, 4}} = Parser.parse_instruction(memory, 0)
    )

    assert(%Instruction{op_code: :halt} = Parser.parse_instruction(memory, 4))
  end

  test "parse_instruction/2 builds the add instruction in position mode" do
  end
end
