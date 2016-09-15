defmodule Bex.SingleRoot do
  @moduledoc """
  The root, but only if it's the only node in the tree. Otherwise use Bex.Root
  This node type has records as children and can have between 1 and arity - 1
  keys and corresponding children
  """

  defstruct(
    arity: nil,
    data: %{},
    size: 0
  )

  alias Bex.Leaf
  alias Bex.Root

  def new(arity) do
    %__MODULE__{arity: arity}
  end

  def insert(%{size: size, arity: arity} = tree, key, value) when size < arity - 1 do
    %{tree | size: size + 1, data: Map.put(tree.data, key, value)}
  end

  def insert(%{size: size, arity: arity} = tree, key, value) when size == arity - 1 do
    data = Map.put(tree.data, key, value)
    data_list = data |> Enum.to_list |> Enum.sort
    left_size = div(tree.size, 2)
    {left_data, right_data} = data_list |> Enum.split(left_size)

    left_leaf = Leaf.new(arity, left_data)
    right_leaf = Leaf.new(arity, right_data)
    {root_key, _value} = right_data |> hd
    Root.new(arity, root_key, left_leaf, right_leaf)
  end

  def find(tree, key) do
    case Map.has_key?(tree.data, key) do
      false -> {:error, :not_found}
      true -> {:ok, Map.get(tree.data, key)}
    end
  end

  def height(_tree), do: 1
end

defimpl Bex.Tree, for: Bex.SingleRoot do
  def insert(tree, key, value), do: Bex.SingleRoot.insert(tree, key, value)
  def find(tree, key), do: Bex.SingleRoot.find(tree, key)
  def height(tree), do: Bex.SingleRoot.height(tree)
end
