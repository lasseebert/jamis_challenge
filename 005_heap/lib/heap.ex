defmodule Heap do
  @moduledoc """
  A heap structure implemented with a binary tree as data structure.
  The heap operations and structure is taken from this paper:
  [A Functional Approach to Standard Binary Heaps<Paste>](http://arxiv.org/abs/1312.4666)

  Each node in the tree keeps track of the size and height of the subtree it
  represents. This allows for O(log n) insert and remove operations.
  """

  alias Heap.Tree

  defstruct(
    compare: &Kernel.</2,
    root: Tree.new
  )

  def new do
    %__MODULE__{}
  end

  @doc """
  Returns the top value
  """
  def peak(heap) do
    heap.root.value
  end

  @doc """
  Returns the number of nodes
  """
  def size(heap) do
    heap.root.size
  end

  @doc """
  Returns the height of the binary tree
  """
  def height(heap) do
    heap.root.height
  end

  @doc """
  Inserts the value into the heap.
  Returns the updated heap
  """
  def insert(heap, value) do
    %{heap | root: Tree.insert(heap.root, value, heap.compare)}
  end

  @doc """
  Removes the top value of the heap
  Returns {value, updated_heap}
  """
  def remove(heap) do
    with {:ok, value, tree} <- Tree.remove(heap.root, heap.compare) do
      {:ok, value, %{heap | root: tree}}
    end
  end
end
