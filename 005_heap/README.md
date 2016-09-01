# Heap

Solution for Weekly Programming Challenge #5 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-5-e7677458f646

## The heap structure

I implemented a heap using mostly this document:
[A Functional Approach to Standard Binary Heaps](http://arxiv.org/abs/1312.4666)

It does insert and remove functions in O(log n) time and peak in O(1)
time.

See [Heap](lib/heap.ex) and [Heap.Tree](lib/heap/tree.ex)

It supports using a custom comparison function.


## The queue

The priority queue is a thin wrapper on top of the heap.

See [Heap.Queue](lib/heap/queue.ex)


## Huffman coder

I used the priority queue to implement a huffman coder. It can

* Compose an encoding from a text
* Use the encoding to encode a text
* Include the encoding within the encoded text
* Pad the result to a whole number of bytes
* Decode

Example with including the encoding within the encoded text:

```elixir
$ iex -S mix
# Encode and decode
iex(1)> alias Heap.Huffman
iex(2)> text = File.read!("lib/heap/huffman.ex")
iex(3)> encoded = Huffman.encode(text)
<<0, 0, 0, 129, 0, 0, 0, 0, 0, 0, 104, 0, 108, 0, 0, 0, 93, 91, 0, 77, 56, 61,
  97, 0, 44, 0, 0, 0, 0, 64, 50, 0, 0, 0, 67, 68, 119, 48, 46, 112, 0, 0, 115,
  103, 100, 32, 0, 0, 0, 0, ...>>
iex(4)> decoded = Huffman.decode(encoded)
iex(5)> decoded == text
true

# Verify compression
iex(6)> decoded |> String.length
4034
iex(7)> encoded |> String.length
2351

# Just get the encoding
iex(8)> Huffman.create_encoding(text)
{{{{{{"h", {"l", {{{"]", "["}, {"M", "8"}}, "="}}}, "a"},
    {",", {{{{"@", "2"}, {{{"C", "D"}, "w"}, "0"}}, "."}, "p"}}},
   {{"s", "g"}, "d"}}, " "},
 {{{{{"f", ":"}, {{{"z", "-"}, {"|", "1"}}, "("}}, "n"},
   {{{")", {"b", "m"}},
     {">",
      {{"x", {"E", "Q"}},
       {{{"/", {"T", "%"}}, {{"~", {"k", "v"}}, "\\"}}, "q"}}}}, {"\n", "o"}}},
  {{{{{"\"", "<"},
      {{"y", "{"}, {{{{{"A", "j"}, "&"}, "H"}, {"3", {"+", "S"}}}, "}"}}}, "c"},
    {"r", "t"}}, {{{"u", "_"}, "i"}, "e"}}}}
```
