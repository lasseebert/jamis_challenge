defmodule Bex.InternalNode do
  @moduledoc """
  Node somewhere between root and leaf.
  Kan have from arity / 2 to arity children
  """

  defstruct(
    arity: nil,
    keys: [],
    children: [],
    size: 0
  )

  def new(arity, keys, children) do
    %__MODULE__{
      arity: arity,
      keys: keys,
      children: children,
      size: children |> Enum.count
    }
  end

  #def insert(tree, key, value) do
  #  child_index = child_index(tree, key)
  #  {left_children, [child | right_children]} = Enum.split(tree.children, child_index)

  #  case Bex.insert(child, key, value) do
  #    {left, right, new_key} ->
  #      %{
  #        tree |
  #        children: [left_children, left, right, right_children] |> List.flatten,
  #        keys: [new_key | tree.keys] |> Enum.sort,
  #        size: tree.size + 1
  #      }
  #      |> normalize
  #    new_child ->
  #      %{tree | children: [left_children, new_child, right_children] |> List.flatten}
  #  end
  #end

  def find(tree, key) do
    tree.children
    |> Enum.at(child_index(tree, key))
    |> Bex.find(key)
  end

  def height(tree) do
    1 + Bex.height(tree.children |> hd)
  end

  defp child_index(tree, key) do
    case tree.keys |> Enum.find_index(fn k -> k > key end) do
      nil -> tree.size - 1
      n -> n
    end
  end

  #defp normalize(%{arity: arity, size: size} = tree) when arity + 1 == size do
  #  root_key_index = div(arity, 2)
  #  {left_keys, [root_key | right_keys]} = Enum.split(tree.keys, root_key_index)
  #  {left_children, right_children} = Enum.split(tree.children, root_key_index + 1)

  #  left = InternalNode.new(arity, left_keys, left_children)
  #  right = InternalNode.new(arity, right_keys, right_children)
  #  new(arity, root_key, left, right)
  #end
  #defp normalize(tree) do
  #  tree
  #end
end

defimpl Bex.Tree, for: Bex.InternalNode do
  def insert(tree, key, value), do: Bex.InternalNode.insert(tree, key, value)
  def find(tree, key), do: Bex.InternalNode.find(tree, key)
  def height(tree), do: Bex.InternalNode.height(tree)
end
