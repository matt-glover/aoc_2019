defmodule IntcodeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "load_program/1 returns an initialized program" do
    assert(%Intcode.Program{} = Intcode.load_program("1,2,3,1,99"))
  end

  test "load_program/1 initializes program memory and points to first instruction" do
    %Intcode.Program{memory: memory, instruction_pointer: pointer} =
      Intcode.load_program("1,2,3,1,99")

    assert %Intcode.Memory{} = memory
    assert pointer == 0
  end

  test "run_program/1 executes the loaded program until it halts" do
    program = Intcode.load_program("1,2,4,0,99")
    assert Intcode.run_program(program) == 103
  end

  test "run_program/1 day 5 part 2 comparison tests" do
    cases = [
      # Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
      {"3,9,8,9,10,9,4,9,99,-1,8", "8\n", "9\n"},
      # Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
      {"3,9,7,9,10,9,4,9,99,-1,8", "7\n", "8\n"},
      # Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
      {"3,3,1108,-1,8,3,4,3,99", "8\n", "9\n"},
      # Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
      {"3,3,1107,-1,8,3,4,3,99", "7\n", "8\n"}
    ]

    Enum.each(cases, fn {source, input_one, input_zero} ->
      assert capture_io([input: input_one, capture_prompt: false], fn ->
               Intcode.load_program(source)
               |> Intcode.run_program()
             end) == "Output: 1\n"

      assert capture_io([input: input_zero, capture_prompt: false], fn ->
               Intcode.load_program(source)
               |> Intcode.run_program()
             end) == "Output: 0\n"
    end)
  end

  test "run_program/1 day 5 part 2 jump tests" do
    # Here are some jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero:
    cases = [
      # (using position mode)
      "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9",
      # (using immediate mode)
      "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
    ]

    Enum.each(cases, fn source ->
      assert capture_io([input: "0\n", capture_prompt: false], fn ->
               Intcode.load_program(source)
               |> Intcode.run_program()
             end) == "Output: 0\n"

      assert capture_io([input: "5\n", capture_prompt: false], fn ->
               Intcode.load_program(source)
               |> Intcode.run_program()
             end) == "Output: 1\n"
    end)
  end

  test "run_program/1 day 5 part 2 larger tests" do
    source =
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31," <>
        "1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104," <>
        "999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

    program = Intcode.load_program(source)

    assert capture_io([input: "2\n", capture_prompt: false], fn ->
             Intcode.run_program(program)
           end) == "Output: 999\n"

    assert capture_io([input: "8\n", capture_prompt: false], fn ->
             Intcode.run_program(program)
           end) == "Output: 1000\n"

    assert capture_io([input: "11\n", capture_prompt: false], fn ->
             Intcode.run_program(program)
           end) == "Output: 1001\n"
  end
end
