defmodule Bex.Leaf do
  @moduledoc """
  A leaf node containing arity - 1 keys and children. Each child is some data.
  Minimum size is arity / 2
  """

  defstruct(
    arity: nil,
    data: %{},
    size: 0
  )

  def new(arity, data_list) do
    %__MODULE__{
      arity: arity,
      data: data_list |> Enum.into(%{}),
      size: data_list |> Enum.count
    }
  end

  def insert(%{size: size, arity: arity} = tree, key, value) when size < arity - 1 do
    %{tree | size: size + 1, data: Map.put(tree.data, key, value)}
  end

  def insert(%{size: size, arity: arity} = tree, key, value) when size == arity - 1 do
    data = Map.put(tree.data, key, value)
    data_list = data |> Enum.to_list |> Enum.sort
    left_size = div(tree.size, 2)
    {left_data, right_data} = data_list |> Enum.split(left_size)

    left_leaf = new(arity, left_data)
    right_leaf = new(arity, right_data)
    {root_key, _value} = right_data |> hd
    {left_leaf, right_leaf, root_key}
  end

  def find(tree, key) do
    case Map.has_key?(tree.data, key) do
      false -> {:error, :not_found}
      true -> {:ok, Map.get(tree.data, key)}
    end
  end

  def height(_tree), do: 1
end

defimpl Bex.Tree, for: Bex.Leaf do
  def insert(tree, key, value), do: Bex.Leaf.insert(tree, key, value)
  def find(tree, key), do: Bex.Leaf.find(tree, key)
  def height(tree), do: Bex.Leaf.height(tree)
end
