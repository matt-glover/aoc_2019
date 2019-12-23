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

  test "translate_op_code/1 converts raw ints to all position mode" do
    assert {:add, [:position, :position, :position_write]} == Parser.translate_op_code("1")
    assert {:multiply, [:position, :position, :position_write]} == Parser.translate_op_code("2")
    assert {:input, [:position_write]} == Parser.translate_op_code("3")
    assert {:output, [:position]} == Parser.translate_op_code("4")
    assert {:halt, []} == Parser.translate_op_code("99")
  end

  test "translate_op_code/1 converts ones and zeroes into appropriate modes" do
    expectations = %{
      "1002" => {:multiply, [:position, :immediate, :position_write]},
      "01101" => {:add, [:immediate, :immediate, :position_write]},
      "104" => {:output, [:immediate]},
      "003" => {:input, [:position_write]},
      "02" => {:multiply, [:position, :position, :position_write]},
      "01102" => {:multiply, [:immediate, :immediate, :position_write]}
    }

    Enum.each(expectations, fn {op_code, expected} ->
      assert expected == Parser.translate_op_code(op_code)
    end)
  end
end
