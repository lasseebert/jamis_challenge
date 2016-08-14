defmodule Maze do
  defstruct(
    width: 0,
    height: 0,
    start_point: {0, 0},
    exit_point: {0, 0},
    walls: MapSet.new
  )

  def add_wall(maze, point) do
    %{maze | walls: MapSet.put(maze.walls, point)}
  end

  def wall?(maze, point) do
    maze.walls
    |> MapSet.member?(point)
  end
end
