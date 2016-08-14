defmodule Maze.Solver do
  def shortest_route(maze) do
    shotest_route(
      maze,
      :queue.in({maze.start_point, 0, []}, :queue.new),
      MapSet.new
    )
  end

  defp shotest_route(maze, queue, visited) do
    {{:value, {{x, y} = pos, dist, route}}, queue} = :queue.out(queue)

    cond do
      Maze.wall?(maze, pos) ->
        shotest_route(maze, queue, visited)
      MapSet.member?(visited, pos) ->
        shotest_route(maze, queue, visited)
      maze.exit_point == pos ->
        Enum.reverse(route)
      true ->
        queue = :queue.in({{x + 1, y}, dist + 1, ["East" | route]}, queue)
        queue = :queue.in({{x - 1, y}, dist + 1, ["West" | route]}, queue)
        queue = :queue.in({{x, y + 1}, dist + 1, ["North" | route]}, queue)
        queue = :queue.in({{x, y - 1}, dist + 1, ["South" | route]}, queue)
        visited = MapSet.put(visited, pos)
        shotest_route(maze, queue, visited)
    end
  end
end
