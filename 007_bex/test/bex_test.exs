defmodule BexTest do
  use ExUnit.Case

  test "insert and search in a small tree" do
    tree =
      Bex.new
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 3) == {:error, :not_found}
    assert Bex.height(tree) == 1
  end

  @tag :skip
  test "insert and search" do
    tree =
      Bex.new
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")
      |> Bex.insert(4, "four")
      |> Bex.insert(5, "five")
      |> Bex.insert(6, "six")
      |> Bex.insert(7, "seven")
      |> Bex.insert(8, "eight")

    assert Bex.find(tree, 6) == {:ok, "six"}
    assert Bex.find(tree, 9) == {:error, :not_found}
  end
end
