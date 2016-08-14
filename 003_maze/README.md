# Maze

Solution for Weekly Programming Challenge #3 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-3-932b16ddd957

The solution uses a simple breadth-first algortihm, which is able to solve any
maze.

Usage:

```elixir
solution = "test/mazes/maze-hard-010.txt"
|> Maze.Parser.from_file
|> Maze.Solver.shortest_route

solution
|> Enum.join("\n")
|> IO.puts

IO.puts("#{length(solution)} steps")
```

Produces:

```
south
east
east
south
south
east
east
east
east
north
north
east
east
east
east
south
south
west
west
south
south
west
west
south
south
east
east
south
south
south
south
south
south
west
west
south
south
west
west
south
south
east
east
east
east
east
east
south
south
east
east
south
south
south
south
west
west
south
south
south
south
west
west
south
south
east
east
east
east
east
east
south
south
south
south
east
east
south
south
east
east
east
east
south
south
east
east
south
south
east
east
east
east
east
east
north
north
west
west
99 steps
```
