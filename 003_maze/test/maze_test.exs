defmodule MazeTest do
  use ExUnit.Case

  describe "wall?" do
    test "the maze is surrounded by walls" do
      maze = %Maze{width: 2, height: 2}

      assert Maze.wall?(maze, {-1, 0})
      assert Maze.wall?(maze, {0, -1})
      assert Maze.wall?(maze, {2, 0})
      assert Maze.wall?(maze, {0, 2})
    end
  end
end
