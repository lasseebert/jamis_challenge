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

  test "inserting through internal nodes" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")
      |> Bex.insert(4, "four")
      |> Bex.insert(5, "five")
      |> Bex.insert(6, "six")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 6) == {:ok, "six"}
    assert Bex.find(tree, 9) == {:error, :not_found}
    assert Bex.height(tree) == 3
  end

  test "splitting internal nodes" do
    tree =
      Bex.new(3)
      |> Bex.insert(1, "one")
      |> Bex.insert(2, "two")
      |> Bex.insert(3, "three")
      |> Bex.insert(4, "four")
      |> Bex.insert(5, "five")
      |> Bex.insert(6, "six")
      |> Bex.insert(7, "seven")

    assert Bex.find(tree, 1) == {:ok, "one"}
    assert Bex.find(tree, 7) == {:ok, "seven"}
    assert Bex.find(tree, 9) == {:error, :not_found}
    assert Bex.height(tree) == 3
  end

  test "adding a bunch of values" do
    tree = Bex.new(10)
    values = 0..1000 |> Enum.shuffle
    tree = Enum.reduce(values, tree, fn value, tree -> Bex.insert(tree, value, "#{value}") end)

    assert Bex.find(tree, 1) == {:ok, "1"}
    assert Bex.find(tree, 7) == {:ok, "7"}
    assert Bex.find(tree, 722) == {:ok, "722"}
    assert Bex.find(tree, 1001) == {:error, :not_found}
    assert Bex.height(tree) < 5
  end
end
