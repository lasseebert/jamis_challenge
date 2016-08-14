defmodule Maze.SolverTest do
  use ExUnit.Case

  alias Maze.Solver
  alias Maze.Parser

  def short_notation(solution) do
    solution
    |> Enum.map(&String.first/1)
    |> Enum.reduce([], fn
      dir, [{dir, n} | rest] -> [{dir, n + 1} | rest]
      dir, list -> [{dir, 1} | list]
    end)
    |> Enum.reverse
    |> Enum.map(fn {dir, n} -> "#{n}#{dir}" end)
    |> Enum.join(" ")
  end

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
    |> short_notation

    assert solution == "1E 1N"
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
    |> short_notation

    assert solution == "2N"
  end

  test "it solves big empty maze" do
    solution = %Maze{
      width: 100,
      height: 100,
      start_point: {0, 0},
      exit_point: {99, 99},
    }
    |> Solver.shortest_route
    |> short_notation

    assert solution == "99E 99N"
  end

  test "it solves normal-001" do
    solution = "test/mazes/maze-normal-001.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "9N 6E 2S 2E 2S 4W 2N 2W 7S"
  end

  test "it solves normal-002" do
    solution = "test/mazes/maze-normal-002.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "7E 4N 2W 2S 4W 2N 2E"
  end

  test "it solves normal-003" do
    solution = "test/mazes/maze-normal-003.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "5S 2W 2S 2W 2S 2W 6N 2W 7S"
  end

  test "it solves normal-010" do
    solution = "test/mazes/maze-normal-010.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "1W 8N 2W 4S 8W 2S 4W 2N 2E 2N 2W 2N 8W 2S 4W 2N 2W 2S 2W 2N 2W 2S 6W 2S 4E 2S 2W 2S 2W 2S 4E 4S 2E 4S 4W 2S 2W 4S 6E 4S 2W 2S 2W 4N 2W 6S 2E 6S 2W 4N 1W"
  end

  test "it solves hard-001" do
    solution = "test/mazes/maze-hard-001.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "5S 2W 4N 6W 2S 4E 4S 4W 2S 6E 2N 2E 3S"
  end

  test "it solves hard-005" do
    solution = "test/mazes/maze-hard-005.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "2W 2N 4E 2S 6E 2S 2E 4S 6W 2S 4E 2S 2W 2S 2E 2S 2W 2S 10E 2N 2W"
  end

  test "it solves hard-010" do
    solution = "test/mazes/maze-hard-010.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "1S 2E 2S 4E 2N 4E 2S 2W 2S 2W 2S 2E 6S 2W 2S 2W 2S 6E 2S 2E 4S 2W 4S 2W 2S 6E 4S 2E 2S 4E 2S 2E 2S 6E 2N 2W"
  end
end
