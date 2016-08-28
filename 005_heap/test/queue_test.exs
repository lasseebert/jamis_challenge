defmodule Heap.QueueTest do
  use ExUnit.Case

  alias Heap.Queue

  test "using default comparison" do
    queue =
      Queue.new
      |> Queue.enqueue(3, "kiwi")
      |> Queue.enqueue(1, "apple")
      |> Queue.enqueue(2, "banana")

    {v1, queue} = Queue.dequeue(queue)
    {v2, queue} = Queue.dequeue(queue)
    {v3, queue} = Queue.dequeue(queue)

    assert v1 == "apple"
    assert v2 == "banana"
    assert v3 == "kiwi"
    assert Queue.size(queue) == 0
  end

  test "using a custom comparison function" do
    queue =
      Queue.new(&(-&1))
      |> Queue.enqueue(3, "kiwi")
      |> Queue.enqueue(1, "apple")
      |> Queue.enqueue(2, "banana")

    {v1, queue} = Queue.dequeue(queue)
    {v2, queue} = Queue.dequeue(queue)
    {v3, queue} = Queue.dequeue(queue)

    assert v1 == "kiwi"
    assert v2 == "banana"
    assert v3 == "apple"
    assert Queue.size(queue) == 0
  end
end
