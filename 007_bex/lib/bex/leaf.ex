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

  def find(tree, key) do
    case Map.has_key?(tree.data, key) do
      false -> {:error, :not_found}
      true -> {:ok, Map.get(tree.data, key)}
    end
  end

  def height(_tree), do: 1
end

defimpl Bex.Tree, for: Bex.Leaf do
  def insert(_tree, _key, _value), do: :not_implemented
  def find(tree, key), do: Bex.Leaf.find(tree, key)
  def height(tree), do: Bex.Leaf.height(tree)
end
