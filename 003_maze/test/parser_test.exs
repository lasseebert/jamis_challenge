defmodule Maze.ParserTest do
  use ExUnit.Case

  test "it loads a test maze from file" do
    maze = Maze.Parser.from_file("test/mazes/maze-normal-001.txt")

    assert maze.width == 11
    assert maze.height == 11
    assert maze.start_point == {1, 0}
    assert maze.exit_point == {3, 0}
    assert Maze.wall?(maze, {0, 0})
    assert Maze.wall?(maze, {2, 1})
    refute Maze.wall?(maze, {1, 0})
    refute Maze.wall?(maze, {2, 9})
  end
end
