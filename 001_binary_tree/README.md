# BinaryTree

Solution for Weekly Programming Challenge #1 by Jamis Buck.
See: https://medium.com/@jamis/weekly-programming-challenge-1-55b63b9d2a1#.dsxrmigmg

The tree is a self balancing AA tree. See
[tests](https://github.com/lasseebert/binary_tree/blob/master/test/binary_tree_test.exs)
and
[code](https://github.com/lasseebert/binary_tree/blob/master/lib/binary_tree.ex).

Usage:

```elixir
tree = BinaryTree.new
|> BinaryTree.insert(100, "oh yeah")
|> BinaryTree.insert(42, "forty-two")
|> BinaryTree.insert(31, "cya")
|> BinaryTree.delete(100)

BinaryTree.search(tree, 42)
# => "forty-two"
```
