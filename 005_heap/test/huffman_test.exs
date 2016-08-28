defmodule Heap.HuffmanTest do
  use ExUnit.Case

  alias Heap.Huffman

  test "encode and decode a string" do
    text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum at libero sit amet auctor. Proin sit amet leo urna. Curabitur vel risus nisl. Mauris at lacus nec neque imperdiet vestibulum et vel tortor. Quisque facilisis ac lacus ut tincidunt. Phasellus suscipit turpis eget placerat commodo. Fusce et eleifend ipsum."
    encoding = Huffman.create_encoding(text)
    encoded = Huffman.encode(encoding, text)
    decoded = Huffman.decode(encoding, encoded)

    assert text == decoded
    assert byte_size(encoded) < byte_size(text)
  end

  test "unicode chars"

  test "including the generator" do
    text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum at libero sit amet auctor. Proin sit amet leo urna. Curabitur vel risus nisl. Mauris at lacus nec neque imperdiet vestibulum et vel tortor. Quisque facilisis ac lacus ut tincidunt. Phasellus suscipit turpis eget placerat commodo. Fusce et eleifend ipsum."

    encoded = Huffman.encode(text)
    decoded = Huffman.decode(encoded)

    assert text == decoded
    assert byte_size(encoded) < byte_size(text)
  end
end
