defmodule Bex.Root do
  @moduledoc """
  Root in the tree. Has between 2 and arity children.
  """

  defstruct(
    arity: nil,
    data: %{},
    last_child: nil,
    size: 0
  )

  def new(arity, key, left, right) do
    %__MODULE__{
      arity: arity,
      data: %{key => left},
      last_child: right,
      size: 2
    }
  end

  def find(tree, key) do
    data_list = tree.data |> Enum.to_list |> Enum.sort

    case data_list |> Enum.find(fn {k, _child} -> k > key end) do
      nil -> Bex.find(tree.last_child, key)
      {_k, child} -> Bex.find(child, key)
    end
  end

  def height(tree) do
    1 + Bex.height(tree.last_child)
  end
end

defimpl Bex.Tree, for: Bex.Root do
  def insert(_tree, _key, _value), do: :not_implemented
  def find(tree, key), do: Bex.Root.find(tree, key)
  def height(tree), do: Bex.Root.height(tree)
end
