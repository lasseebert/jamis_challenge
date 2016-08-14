defmodule Maze.Parser do
  def from_file(path) do
    File.read!(path)
    |> from_string
  end

  @doc """
  Expects a maze_string in the format:

  # is a wall
  space is a passage
  O is the start point
  X is the exit point
  """
  def from_string(maze_string) do
    maze_string
    |> String.split("\n")
    |> Enum.reverse
    |> Enum.reduce(%Maze{}, fn line, maze -> parse_line(maze, line) end)
  end

  defp parse_line(maze, "") do
    maze
  end
  defp parse_line(maze, line) do
    {maze, _} = line
                |> String.to_char_list
                |> Enum.reduce({maze, {0, maze.height}}, fn
                  char, {maze, {x, y} = point} ->
                    maze = parse_char(maze, char, point)
                    {maze, {x + 1, y}}
                end)

    %{
      maze |
      width: String.length(line),
      height: maze.height + 1
    }
  end

  # Space is \s
  defp parse_char(maze, ?\s, _point) do
    maze
  end
  defp parse_char(maze, ?#, point) do
    Maze.add_wall(maze, point)
  end
  defp parse_char(maze, ?O, point) do
    %{maze | start_point: point}
  end
  defp parse_char(maze, ?X, point) do
    %{maze | exit_point: point}
  end
end
