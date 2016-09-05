defmodule Perlin do
  @moduledoc """
  Can generate Perlin noise
  """

  alias Perlin.Grid

  @doc """
  Generates a map of pixels {x, y} => value.
  """
  def generate({image_width, image_height}, {grid_width, grid_height}) do
    grid = Grid.new(grid_width, grid_height)

    for pixel_x <- (0..image_width - 1), pixel_y <- (0..image_height - 1) do
      perlin_x = pixel_x / image_width * grid_width
      perlin_y = pixel_y / image_height * grid_height
      value = perlin(grid, perlin_x, perlin_y)
      {{pixel_x, pixel_y}, value}
    end
    |> Enum.into(%{})
  end

  @doc """
  Generate Perlin noise using several octaves
  """
  def generate({_, _} = dimensions, min_octave \\ 2, max_octave \\ 4, persistance \\ 0.9) do
    {image, _amp, max} =
      for octave <- (min_octave..max_octave) do
        grid_size = :math.pow(2, octave) |> trunc
        generate(dimensions, {grid_size, grid_size})
      end
      |> Enum.reduce({%{}, 1, 0}, fn image, {total_image, amplitude, max} ->
        total_image = Map.merge(total_image, image, fn _key, v1, v2 -> v1 + v2 * amplitude end)
        max = max + amplitude
        amplitude = amplitude * persistance
        {total_image, amplitude, max}
      end)

    image
    |> Enum.map(fn {pos, value} -> {pos, value / max} end)
    |> Enum.into(%{})
  end

  defp perlin(grid, x, y) do
    # Grid position
    grid_x0 = trunc(x)
    grid_y0 = trunc(y)
    grid_x1 = grid_x0 + 1
    grid_y1 = grid_y0 + 1

    # Weights
    weight_x = x - grid_x0
    weight_y = y - grid_y0

    node_factor_nw = node_factor(grid, {x, y}, {grid_x0, grid_y0})
    node_factor_ne = node_factor(grid, {x, y}, {grid_x1, grid_y0})
    node_factor_sw = node_factor(grid, {x, y}, {grid_x0, grid_y1})
    node_factor_se = node_factor(grid, {x, y}, {grid_x1, grid_y1})

    interpolate_n = interpolate(node_factor_nw, node_factor_ne, weight_x)
    interpolate_s = interpolate(node_factor_sw, node_factor_se, weight_x)

    interpolate(interpolate_n, interpolate_s, weight_y)
  end

  defp node_factor(grid, {x, y}, {node_x, node_y}) do
    distance_vector = {x - node_x, y - node_y}
    gradient_vector = Grid.vector(grid, node_x, node_y)

    dot_product(distance_vector, gradient_vector)
  end

  defp dot_product({x0, y0}, {x1, y1}) do
    x0 * x1 + y0 * y1
  end

  defp interpolate(a, b, w) do
    a + smoothen(w) * (b - a)
  end

  defp smoothen(x) do
    (x * x) * (3 - 2 * x)
  end
end
