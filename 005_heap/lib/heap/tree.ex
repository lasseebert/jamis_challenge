defmodule Heap.Tree do
  defstruct(
    value: nil,
    left: nil,
    right: nil,
    size: 0,
    height: 0
  )

  # Leaf
  def new do
    %__MODULE__{}
  end

  # Node with no children
  def new(value) do
    new(value, new, new)
  end

  # Node with children
  def new(value, left, right) do
    %__MODULE__{
      value: value,
      left: left,
      right: right,
      size: left.size + right.size + 1,
      height: Enum.max([left.height, right.height]) + 1
    }
  end

  def complete?(tree), do: tree.size == :math.pow(2, tree.height) - 1
  def empty?(tree), do: tree.size == 0

  # Insert into tree
  def insert(tree, value, compare) do
    cond do
      # Empty tree
      empty?(tree) ->
        new(value)

      # Left tree is not complete. Insert into that
      !complete?(tree.left) ->
        bubble_up(tree.value, insert(tree.left, value, compare), tree.right, compare)

      # Right tree is not complete. Insert into that
      !complete?(tree.right) ->
        bubble_up(tree.value, tree.left, insert(tree.right, value, compare), compare)

      # Both trees are complete, but right tree is smaller than left tree.
      # Insert into that.
      tree.left.height > tree.right.height ->
        bubble_up(tree.value, tree.left, insert(tree.right, value, compare), compare)

      # Both trees are complete and of equal height. Insert into left.
      true ->
        bubble_up(tree.value, insert(tree.left, value, compare), tree.right, compare)
    end
  end

  defp bubble_up(value, left, right, compare) do
    cond do
      needs_bubble?(value, left, compare) ->
        new(left.value, new(value, left.left, left.right), right)
      needs_bubble?(value, right, compare) ->
        new(right.value, left, new(value, right.left, right.right))
      true ->
        new(value, left, right)
    end
  end

  defp needs_bubble?(_x, %{value: nil}, _compare), do: false
  defp needs_bubble?(x, %{value: y}, compare), do: compare.(y, x)
end

defimpl Inspect, for: Heap.Tree do
  import Inspect.Algebra

  def inspect(%{value: nil}, _opts) do
    "#Leaf"
  end
  def inspect(tree, _opts) do
    "#Tree(#{tree.value |> inspect}, (#{tree.height |> inspect}/#{tree.size |> inspect}), left: #{tree.left |> inspect}, right: #{tree.right |> inspect})"
  end
end
