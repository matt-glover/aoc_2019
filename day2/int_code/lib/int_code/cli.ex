defmodule IntCode.CLI do
  @moduledoc """
  CLI interface to the IntCode computer
  """

  def main([]) do
    main(["./input"])
  end

  def main(args) do
    file_path = hd(args)
    IO.puts("Starting with #{file_path}")

    result =
      File.read!(file_path)
      |> String.trim()
      |> IntCode.Compiler.run_program()

    IO.puts("Result: #{result}")
  end
end
