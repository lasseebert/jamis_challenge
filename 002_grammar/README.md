# Grammar

Solution for Weekly Programming Challenge #2 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-2-33ef134b39cd#.6su7w6d6r

## Normal mode

Solved using a small hardcoded grammar.

See [code](lib/grammar/normal.ex)

Usage:

```elixir
1..10 |> Enum.map(fn _ -> Grammar.Normal.generate end)
# => [
#   "Amon Andhoth", "Mithlin-en-Morarrim", "Amon Mithnorhoth", "Morgul",
#   "Mithrim Mithgul", "Nen Celewaith", "Nimras Nimnorgul", "Nen Nimhir",
#   "Minas Andras", "Minas Elarlin"
# ]
```
