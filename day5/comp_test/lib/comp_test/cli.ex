defmodule CompTest.CLI do
  @moduledoc false

  def main(args) do
    file_path = hd(args)
    IO.puts("Starting with #{file_path}")

    source_code =
      File.read!(file_path)
      |> String.trim()

    result =
      Intcode.load_program(source_code)
      |> Intcode.run_program()

    IO.puts("Result: #{result}")
  end
end
