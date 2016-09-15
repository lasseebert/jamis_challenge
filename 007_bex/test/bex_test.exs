defmodule BexTest do
  use ExUnit.Case

  test "insert and search in a small tree" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 3) == {:error, :not_found}
    assert Bex.height(tree) == 1
  end

  test "adding leaf nodes" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 3) == {:ok, "three"}
    assert Bex.find(tree, 9) == {:error, :not_found}
    assert Bex.height(tree) == 2
  end

  test "adding to a Root node" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")
      |> Bex.insert(4, "four")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 4) == {:ok, "four"}
    assert Bex.find(tree, 9) == {:error, :not_found}
    assert Bex.height(tree) == 2
  end

  test "using internal nodes" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")
      |> Bex.insert(4, "four")
      |> Bex.insert(5, "five")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 5) == {:ok, "five"}
    assert Bex.find(tree, 9) == {:error, :not_found}
    assert Bex.height(tree) == 3
  end
end
