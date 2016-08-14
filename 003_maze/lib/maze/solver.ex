defmodule Maze.Solver do
  def shortest_route(maze) do
    routes(maze, maze.start_point, [])
    |> Enum.min_by(&length/1)
  end

  defp routes(maze, {x, y} = pos, route) do
    cond do
      Maze.wall?(maze, pos) ->
        []
      maze.exit_point == pos ->
        [Enum.reverse(route)]
      true ->
        maze = Maze.add_wall(maze, pos)
        routes(maze, {x + 1, y}, ["East" | route]) ++
        routes(maze, {x - 1, y}, ["West" | route]) ++
        routes(maze, {x, y + 1}, ["North" | route]) ++
        routes(maze, {x, y - 1}, ["South" | route])
    end
  end
end
