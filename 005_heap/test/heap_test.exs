defmodule HeapTest do
  use ExUnit.Case

  test "creating a new heap" do
    heap = Heap.new

    assert Heap.peak(heap) == nil
    assert Heap.size(heap) == 0
    assert Heap.height(heap) == 0
  end

  test "inserting and removing a single value" do
    heap = Heap.new
            |> Heap.insert(1)

    assert Heap.peak(heap) == 1
    assert Heap.size(heap) == 1
    assert Heap.height(heap) == 1

    {value, heap} = Heap.remove(heap)

    assert value == 1
    assert heap == Heap.new
  end

  test "inserting and removing a bunch og values" do
    heap = (1..100)
            |> Enum.shuffle
            |> Enum.reduce(Heap.new, &(Heap.insert(&2, &1)))

    assert Heap.peak(heap) == 1
    assert Heap.size(heap) == 100
    assert Heap.height(heap) == 7

    heap = (1..100)
            |> Enum.reduce(heap, fn expected, heap ->
              {value, heap} = Heap.remove(heap)
              assert value == expected
              heap
            end)

    assert heap == Heap.new
  end
end
