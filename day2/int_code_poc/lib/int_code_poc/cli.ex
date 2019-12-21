defmodule IntCodePoc.CLI do
  @moduledoc """
  CLI interface to the IntCodePoc computer
  """

  def main([]) do
    main(["./input"])
  end

  def main(["find-value"]) do
    IO.puts("Searching for inputs that produce 19690720")

    original_program =
      File.read!("./input")
      |> String.trim()

    matches =
      for noun <- 0..152, verb <- 0..152, match_expected?(original_program, noun, verb) do
        {noun, verb}
      end

    IO.puts("Raw matches: #{inspect(matches)}")
    [{noun, verb} | _] = matches
    IO.puts("Result: #{noun}#{verb}")
  end

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

  defp match_expected?(original_program, input_1, input_2) do
    modified_program =
      original_program
      |> String.split(",")
      |> List.replace_at(1, input_1)
      |> List.replace_at(2, input_2)
      |> Enum.join(",")

    program_output =
      Intcode.load_program(modified_program)
      |> Intcode.run_program()

    program_output == 19_690_720
  end
end
