defmodule Heap.Huffman do
  @moduledoc"""
  A Huffman coder
  """

  alias Heap.Queue

  @doc """
  Creates an encoding schema that can be used to encode and decode
  """
  def create_encoding(text) do
    text
    |> String.split(~r//, trim: true)
    |> Enum.reduce(%{}, fn char, char_counts ->
      Map.update(char_counts, char, 1, &(&1 + 1))
    end)
    |> Enum.reduce(Queue.new, fn {char, count}, queue ->
      Queue.enqueue(queue, count, char)
    end)
    |> process_encoding_queue
  end

  @doc """
  Encode some text using an encoding.
  """
  def encode(encoding, text) do
    scheme = encoder_from_tree(encoding)
    text
    |> String.split(~r//, trim: true)
    |> Enum.reduce(<<>>, fn char, encoded ->
      <<encoded::bitstring, Map.get(scheme, char)::bitstring >>
    end)
  end

  @doc """
  Decode Huffman code with an encoding
  """
  def decode(encoding, bits) do
    do_decode(encoding, encoding, bits, [])
  end

  defp do_decode(_encoding, _tree, <<>>, acc) do
    acc
    |> Enum.reverse
    |> Enum.join
  end
  defp do_decode(encoding, {left, _}, <<0::1, rest::bitstring>>, acc) do
    case left do
      {_, _} -> do_decode(encoding, left, rest, acc)
      char -> do_decode(encoding, encoding, rest, [char | acc])
    end
  end
  defp do_decode(encoding, {_, right}, <<1::1, rest::bitstring>>, acc) do
    case right do
      {_, _} -> do_decode(encoding, right, rest, acc)
      char -> do_decode(encoding, encoding, rest, [char | acc])
    end
  end

  defp process_encoding_queue(queue) do
    case Queue.size(queue) do
      1 ->
        Queue.peak(queue)
      _ ->
        {priority_1, item_1, queue} = Queue.dequeue(queue, return_priority: true)
        {priority_2, item_2, queue} = Queue.dequeue(queue, return_priority: true)

        queue
        |> Queue.enqueue(priority_1 + priority_2, {item_1, item_2})
        |> process_encoding_queue
    end
  end

  defp encoder_from_tree(tree, prefix \\ <<>>, acc \\ %{})
  defp encoder_from_tree({left, right}, prefix, acc) do
    acc = encoder_from_tree(left, << prefix::bitstring, <<0::1>>::bitstring >>, acc)
    encoder_from_tree(right, << prefix::bitstring, <<1::1>>::bitstring >>, acc)
  end
  defp encoder_from_tree(char, prefix, acc) do
    Map.put(acc, char, prefix)
  end
end
