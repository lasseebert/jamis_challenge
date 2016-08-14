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

    assert solution == "1e 1n"
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

    assert solution == "2n"
  end

  test "it return no solution when there are none" do
    # Maze:
    #
    # ----
    # |#X|
    # |O#|
    # ----
    solution = %Maze{
      width: 2,
      height: 2,
      start_point: {0, 0},
      exit_point: {1, 1},
    }
    |> Maze.add_wall({0, 1})
    |> Maze.add_wall({1, 0})
    |> Solver.shortest_route

    assert solution == :none
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

    assert solution == "99e 99n"
  end

  test "it solves normal-001" do
    solution = "test/mazes/maze-normal-001.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "9n 6e 2s 2e 2s 4w 2n 2w 7s"
  end

  test "it solves normal-002" do
    solution = "test/mazes/maze-normal-002.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "7e 4n 2w 2s 4w 2n 2e"
  end

  test "it solves normal-003" do
    solution = "test/mazes/maze-normal-003.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "5s 2w 2s 2w 2s 2w 6n 2w 7s"
  end

  test "it solves normal-010" do
    solution = "test/mazes/maze-normal-010.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "1w 8n 2w 4s 8w 2s 4w 2n 2e 2n 2w 2n 8w 2s 4w 2n 2w 2s 2w 2n 2w 2s 6w 2s 4e 2s 2w 2s 2w 2s 4e 4s 2e 4s 4w 2s 2w 4s 6e 4s 2w 2s 2w 4n 2w 6s 2e 6s 2w 4n 1w"
  end

  test "it solves hard-001" do
    solution = "test/mazes/maze-hard-001.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "5s 2w 4n 6w 2s 4e 4s 4w 2s 6e 2n 2e 3s"
  end

  test "it solves hard-005" do
    solution = "test/mazes/maze-hard-005.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "2w 2n 4e 2s 6e 2s 2e 4s 6w 2s 4e 2s 2w 2s 2e 2s 2w 2s 10e 2n 2w"
  end

  test "it solves hard-010" do
    solution = "test/mazes/maze-hard-010.txt"
                |> Parser.from_file
                |> Solver.shortest_route
                |> short_notation

    assert solution == "1s 2e 2s 4e 2n 4e 2s 2w 2s 2w 2s 2e 6s 2w 2s 2w 2s 6e 2s 2e 4s 2w 4s 2w 2s 6e 4s 2e 2s 4e 2s 2e 2s 6e 2n 2w"
  end
end
