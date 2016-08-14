defmodule Maze.SolverTest do
  use ExUnit.Case

  alias Maze.Solver

  test "it solves very simple maze" do
    # Maze:
    #
    # ----
    # |#X|
    # |O |
    # ----
    solution = %Maze{
      width: 2,
      height: 2,
      start_point: {0, 0},
      exit_point: {1, 1},
    }
    |> Maze.add_wall({0, 1})
    |> Solver.shortest_route

    assert solution == ["East", "North"]
  end

  test "it finds shortest path of simple maze" do
    # Maze:
    #
    # -----
    # |X  |
    # | # |
    # |O  |
    # -----
    solution = %Maze{
      width: 3,
      height: 3,
      start_point: {0, 0},
      exit_point: {0, 2},
    }
    |> Maze.add_wall({1, 1})
    |> Solver.shortest_route

    assert solution == ["North", "North"]
  end
end
