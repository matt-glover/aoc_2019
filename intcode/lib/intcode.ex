defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as the initial state for the computer's
  memory. When you run an Intcode program, make sure to start by initializing memory to the program's values. A
  position in memory is called an address (for example, the first value in memory is at "address 0").

  Opcodes (like 1, 2, or 99) mark the beginning of an instruction. The values used immediately after an opcode, if any,
  are called the instruction's parameters. For example, in the instruction 1,2,3,4, 1 is the opcode; 2, 3, and 4 are
  the parameters. The instruction 99 contains only an opcode and has no parameters.

  The address of the current instruction is called the instruction pointer; it starts at 0. After an instruction
  finishes, the instruction pointer increases by the number of values in the instruction; until you add more
  instructions to the computer, this is always 4 (1 opcode + 3 parameters) for the add and multiply instructions. (The
  halt instruction would increase the instruction pointer by 1, but it halts the program instead.)
  """

  @doc """
  Load a program from a raw source code string representation
  """
  def load_program(source_code) do
    %Intcode.Program{memory: Intcode.Memory.new(source_code)}
  end

  @doc """
  Execute a loaded program until it halts
  """
  def run_program(
        %Intcode.Program{memory: memory, instruction_pointer: pointer} = initialized_program
      ) do
    instruction = Intcode.Memory.read_instruction(memory, pointer)

    case process_instruction(memory, instruction) do
      {:halt, memory} ->
        memory

      {:continue, instruction_offset, updated_memory} ->
        updated_program = %{
          initialized_program
          | memory: updated_memory,
            instruction_pointer: pointer + instruction_offset
        }

        run_program(updated_program)
    end
  end

  defp process_instruction(memory, %Intcode.Instruction{op_code: :halt}) do
    {:halt, Intcode.Memory.read_memory(memory, 0)}
  end

  defp process_instruction(memory, instruction = %Intcode.Instruction{parameters: parameters}) do
    updated_memory = Intcode.Instruction.apply_instruction(memory, instruction)
    # + 1 to account for the op_code itself
    {:continue, tuple_size(parameters) + 1, updated_memory}
  end
end
