defmodule Perlin.Grid do
  @moduledoc """
  Represents a grid in a Perlin noise algorithm
  """

  @doc """
  Initialize a new grid with random gradient vectors
  """
  def new(width, height) do
    # Note that we make an extra node on both axis
    for x <- (0..width), y <- (0..height) do
      {{x, y}, random_vector}
    end
    |> Enum.into(%{})
  end

  @doc """
  Get the gradient vector at a given point
  """
  def vector(grid, x, y) do
    Map.get(grid, {x, y})
  end

  defp random_vector do
    radians = :rand.uniform * :math.pi * 2
    {:math.cos(radians), :math.sin(radians)}
  end
end
