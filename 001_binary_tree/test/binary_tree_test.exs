defmodule BinaryTreeTest do
  use ExUnit.Case
  doctest BinaryTree

  describe "insert" do
    test "insert an element to an empty tree" do
      tree = BinaryTree.new
              |> BinaryTree.insert(1)

      assert 1 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
    end

    test "insert two elements in increasing order" do
      tree = BinaryTree.new
              |> BinaryTree.insert(1)
              |> BinaryTree.insert(2)

      assert 2 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
      assert {:ok, 2} == BinaryTree.search(tree, 2)
    end

    test "insert two elements in decreasing order" do
      tree = BinaryTree.new
              |> BinaryTree.insert(2)
              |> BinaryTree.insert(1)

      assert 2 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
      assert {:ok, 2} == BinaryTree.search(tree, 2)
    end

    test "insert a bunch of elements" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5)
              |> BinaryTree.insert(6)
              |> BinaryTree.insert(4)
              |> BinaryTree.insert(3)

      assert 3 == BinaryTree.height(tree)
      assert {:ok, 3} == BinaryTree.search(tree, 3)
      assert {:ok, 4} == BinaryTree.search(tree, 4)
      assert {:ok, 5} == BinaryTree.search(tree, 5)
      assert {:ok, 6} == BinaryTree.search(tree, 6)
    end

    test "insert the same element overwrites it" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5, "fyve")
              |> BinaryTree.insert(5, "five")

      assert 1 == BinaryTree.height(tree)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
    end

    test "it is balanced" do
      tree = 1..1000
              |> Enum.reduce(BinaryTree.new, fn value, tree -> BinaryTree.insert(tree, value) end)

      assert BinaryTree.height(tree) < 30
    end
  end

  describe "search" do
    setup [:build_tree]

    test "it finds existing item", %{tree: tree} do
      assert BinaryTree.search(tree, 3) == {:ok, "three"}
    end

    test "it reports not_found when not found", %{tree: tree} do
      assert BinaryTree.search(tree, 7) == {:error, :not_found}
    end
  end

  describe "delete" do
    setup [:build_tree]

    test "it deletes a leaf", %{tree: tree} do
      tree = BinaryTree.delete(tree, 2)

      assert {:error, :not_found} == BinaryTree.search(tree, 2)
      assert {:ok, "three"} == BinaryTree.search(tree, 3)
    end

    test "it deletes root when only root exists" do
      tree = BinaryTree.new
              |> BinaryTree.insert(2)
              |> BinaryTree.delete(2)
      assert tree == BinaryTree.new
    end

    test "it deletes node with one child", %{tree: tree} do
      tree = BinaryTree.delete(tree, 6)

      assert {:error, :not_found} == BinaryTree.search(tree, 6)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
      assert {:ok, "eight"} == BinaryTree.search(tree, 8)
    end

    test "it deletes node with two children", %{tree: tree} do
      tree = BinaryTree.delete(tree, 3)

      assert {:error, :not_found} == BinaryTree.search(tree, 3)
      assert {:ok, "two"} == BinaryTree.search(tree, 2)
      assert {:ok, "four"} == BinaryTree.search(tree, 4)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
      assert {:ok, "eight"} == BinaryTree.search(tree, 8)
    end

    test "it returns the same tree if key does not exist", %{tree: tree} do
      new_tree = BinaryTree.delete(tree, 7)

      assert new_tree == tree
    end

    test "it is balanced" do
      tree = 1..1000
              |> Enum.reduce(BinaryTree.new, fn value, tree -> BinaryTree.insert(tree, value) end)
      height = BinaryTree.height(tree)

      tree = 1..500
              |> Enum.reduce(tree, fn value, tree -> BinaryTree.delete(tree, value) end)
      new_height = BinaryTree.height(tree)

      assert new_height < height
    end
  end

  test "it keeps constraints intact" do
    # 1. The level of every leaf node is one.
    # 2. The level of every left child is exactly one less than that of its parent.
    # 3. The level of every right child is equal to or one less than that of its parent.
    # 4. The level of every right grandchild is strictly less than that of its grandparent.
    # 5. Every node of level greater than one has two children.

    amount = 100

    tree = 1..amount
            |> Enum.shuffle
            |> Enum.reduce(BinaryTree.new, fn value, tree ->
              tree = BinaryTree.insert(tree, value)
              case check_tree_constraint(tree) do
                :ok -> tree
                error ->
                  IO.inspect(error)
                  IO.inspect(tree)
                  exit(1)
              end
            end)

    tree = 1..amount
            |> Enum.shuffle
            |> Enum.reduce(tree, fn value, tree ->
              new_tree = BinaryTree.delete(tree, value)
              case check_tree_constraint(new_tree) do
                :ok -> new_tree
                error ->
                  IO.puts "Error deleting #{value} from tree"
                  IO.inspect(error)
                  IO.inspect(tree)
                  IO.inspect(new_tree)
                  exit(1)
              end
            end)

    assert tree == BinaryTree.new
  end

  defp check_tree_constraint(tree) do
    with :ok <- check_constraint_1(tree),
         :ok <- check_constraint_2(tree),
         :ok <- check_constraint_3(tree),
         :ok <- check_constraint_4(tree),
         :ok <- check_constraint_5(tree),
         do: :ok
  end

  defp check_constraint_1(nil), do: :ok
  defp check_constraint_1(%{level: 1, left: nil, right: nil}), do: :ok
  defp check_constraint_1(%{left: nil, right: nil} = tree), do: {:error, :constraint_1, tree}
  defp check_constraint_1(%{left: left, right: right}) do
    with :ok <- check_constraint_1(left),
         :ok <- check_constraint_1(right),
         do: :ok
  end

  defp check_constraint_2(nil), do: :ok
  defp check_constraint_2(%{left: nil, right: right}), do: check_constraint_2(right)
  defp check_constraint_2(%{level: level, left: %{level: left_level}}) when level != left_level + 1, do: {:error, :constraint_2}
  defp check_constraint_2(%{left: left, right: right}) do
    with :ok <- check_constraint_2(left),
         :ok <- check_constraint_2(right),
         do: :ok
  end

  defp check_constraint_3(tree), do: :ok
  defp check_constraint_4(tree), do: :ok
  defp check_constraint_5(tree), do: :ok

  defp build_tree(_context) do
    tree = BinaryTree.new
            |> BinaryTree.insert(5, "five")
            |> BinaryTree.insert(6, "six")
            |> BinaryTree.insert(3, "three")
            |> BinaryTree.insert(4, "four")
            |> BinaryTree.insert(2, "two")
            |> BinaryTree.insert(8, "eight")
      %{tree: tree}
  end
end
