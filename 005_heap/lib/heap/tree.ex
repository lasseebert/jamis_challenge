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

  def insert(tree, value, compare) do
    cond do
      # Empty tree
      empty?(tree) ->
        new(value)

      # Left tree is not complete. Insert into that
      !complete?(tree.left) ->
        bubble_up_once(tree.value, insert(tree.left, value, compare), tree.right, compare)

      # Right tree is not complete. Insert into that
      !complete?(tree.right) ->
        bubble_up_once(tree.value, tree.left, insert(tree.right, value, compare), compare)

      # Both trees are complete, but right tree is smaller than left tree.
      # Insert into that.
      tree.left.height > tree.right.height ->
        bubble_up_once(tree.value, tree.left, insert(tree.right, value, compare), compare)

      # Both trees are complete and of equal height. Insert into left.
      true ->
        bubble_up_once(tree.value, insert(tree.left, value, compare), tree.right, compare)
    end
  end

  def remove(%{size: 0} = tree, _compare) do
    {nil, tree}
  end
  def remove(tree, compare) do
    new_tree = merge_children(tree.left, tree.right)
    |> bubble_root_down(compare)
    {tree.value, new_tree}
  end

  defp bubble_up_once(value, left, right, compare) do
    cond do
      needs_bubble_up?(value, left, compare) ->
        new(left.value, new(value, left.left, left.right), right)
      needs_bubble_up?(value, right, compare) ->
        new(right.value, left, new(value, right.left, right.right))
      true ->
        new(value, left, right)
    end
  end

  defp needs_bubble_up?(_x, %{value: nil}, _compare), do: false
  defp needs_bubble_up?(x, %{value: y}, compare), do: compare.(y, x)

  defp bubble_root_down(%{size: 0} = tree, _compare) do
    tree
  end
  defp bubble_root_down(tree, compare) do
    bubble_down(tree.value, tree.left, tree.right, compare)
  end

  # Bubble invalid root value down the tree
  defp bubble_down(value, left, right, compare) do
    cond do
      # We need to bubble down right
      right.size > 0 && compare.(right.value, value) && compare.(right.value, left.value) ->
        new(right.value, left, bubble_down(value, right.left, right.right, compare))

      # We need to bubble down left
      left.size > 0 && compare.(left.value, value) ->
        new(left.value, bubble_down(value, left.left, left.right, compare), right)

      true -> new(value, left, right)
    end
  end

  defp merge_children(left, right) do
    cond do
      empty?(left) && empty?(right) ->
        new

      !complete?(left) ->
        float_left(left.value, merge_children(left.left, left.right), right)

      !complete?(right) ->
        float_right(right.value, left, merge_children(right.left, right.right))

      left.height > right.height ->
        float_left(left.value, merge_children(left.left, left.right), right)

      true ->
        float_right(right.value, left, merge_children(right.left, right.right))
    end
  end

  defp float_left(value, %{size: 0} = left, right) do
    new(value, left, right)
  end
  defp float_left(value, left, right) do
    new(left.value, new(value, left.left, left.right), right)
  end

  defp float_right(value, left, %{size: 0} = right) do
    new(value, left, right)
  end
  defp float_right(value, left, right) do
    new(right.value, left, new(value, right.left, right.right))
  end
end

defimpl Inspect, for: Heap.Tree do
  def inspect(%{value: nil}, _opts) do
    "#Leaf"
  end
  def inspect(tree, _opts) do
    "#Tree(#{tree.value |> inspect}, (#{tree.height |> inspect}/#{tree.size |> inspect}), left: #{tree.left |> inspect}, right: #{tree.right |> inspect})"
  end
end
