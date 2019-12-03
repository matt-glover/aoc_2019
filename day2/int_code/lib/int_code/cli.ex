defmodule IntCode.CLI do
  @moduledoc """
  CLI interface to the IntCode computer
  """

  def main(_args \\ []) do
    IO.puts("Starting")
    result = IntCode.Compiler.run_program(File.read!("./input"))
    IO.puts("Result: #{result}")
  end
end
