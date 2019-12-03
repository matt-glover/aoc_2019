defmodule IntCode.CLI do
  @moduledoc """
  CLI interface to the IntCode computer
  """

  def main(_args \\ []) do
    IO.puts("Starting")

    result =
      File.read!("./input")
      |> String.trim()
      |> IntCode.Compiler.run_program()

    IO.puts("Result: #{result}")
  end
end
