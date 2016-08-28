defmodule Heap.Queue do
  @moduledoc """
  A priority queue implemented with a binary heap
  """

  def new do
    Heap.new(fn {priority, _item} -> priority end)
  end
  def new(compare_by) do
    Heap.new(fn {priority, _item} -> compare_by.(priority) end)
  end

  def enqueue(queue, priority, item) do
    Heap.insert(queue, {priority, item})
  end

  def dequeue(queue, opts \\ []) do
    return_priority = Keyword.get(opts, :return_priority, false)

    {{priority, item}, queue} = Heap.remove(queue)

    if return_priority do
      {priority, item, queue}
    else
      {item, queue}
    end
  end

  def size(queue), do: Heap.size(queue)

  def height(queue), do: Heap.height(queue)

  def peak(queue) do
    {_priority, item} = Heap.peak(queue)
    item
  end
end
