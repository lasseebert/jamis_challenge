defmodule Bex do
  @moduledoc """
  Interface for the four kinds of nodes in the tree
  """

  alias Bex.Tree
  alias Bex.SingleRoot

  def new(arity \\ 3) do
    SingleRoot.new(arity)
  end

  def insert(tree, key, value) do
    Tree.insert(tree, key, value)
  end

  def find(tree, key) do
    Tree.find(tree, key)
  end

  def height(tree) do
    Tree.height(tree)
  end
end
