defmodule FuelCount.RequirementTest do
  use ExUnit.Case

  setup do
    filename = Base.encode16(:crypto.strong_rand_bytes(16))
    file_path = Path.join(System.tmp_dir!(), filename)

    on_exit(fn ->
      File.rm_rf(file_path)
    end)

    test_data =
      [15, 15, 15, 15, 15]
      |> Enum.join("\n")

    File.write!(file_path, test_data)

    {:ok, file_path: file_path}
  end

  test "aggregates all the calculated masses", %{file_path: file_path} do
    assert(FuelCount.Requirement.aggregate(file_path) == 15)
  end
end
