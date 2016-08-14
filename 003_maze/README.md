# Maze

Solution for Weekly Programming Challenge #3 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-3-932b16ddd957

The solution uses a simple breadth-first algortihm, which is able to solve any
maze.

[See the code here](lib/maze/solver.ex)

Usage:

```elixir
solution = "test/mazes/maze-hard-003.txt"
|> Maze.Parser.from_file
|> Maze.Solver.shortest_route

# Output the solution in a nice way:
solution
|> Enum.join("\n")
|> IO.puts
IO.puts("#{length(solution)} steps")
```

Produces:

```
west
north
north
north
north
north
north
west
west
north
north
east
east
north
north
north
north
west
west
west
west
west
west
west
west
west
west
west
west
west
30 steps
```
