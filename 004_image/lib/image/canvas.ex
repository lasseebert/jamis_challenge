defmodule Image.Canvas do
  @moduledoc """
  More complex drawing methods that operates on a raw image
  """

  alias Image.Raw

  @default_color {0, 0, 0}

  @doc """
  Draws a line using Bresenham's line algorithm as described here:
  https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm#Algorithm
  """
  def draw_line(raw, from, to, color \\ @default_color)

  # Swap x and y
  def draw_line(raw, {x0, y0}, {x1, y1}, color) when abs(y1 - y0) > abs(x1 - x0) do
    bresenham_octant_1({y0, x0}, {y1, x1})
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> Enum.reduce(raw, fn position, raw -> Raw.draw_pixel(raw, position, color) end)
  end

  # Normal case
  def draw_line(raw, from, to, color) do
    bresenham_octant_1(from, to)
    |> Enum.reduce(raw, fn position, raw -> Raw.draw_pixel(raw, position, color) end)
  end

  # Swap from and to
  defp bresenham_octant_1({x0, _} = from, {x1, _} = to) when x0 > x1 do
    bresenham_octant_1(to, from)
  end
  defp bresenham_octant_1({x0, y0}, {x1, y1}) do
    delta_x = x1 - x0
    delta_y = y1 - y0 |> abs
    error = delta_y - delta_x
    y_step = if y0 < y1, do: 1, else: -1

    {_, _, positions} =
      (x0..x1)
      |> Enum.reduce({error, y0, []}, fn x, {error, y, positions} ->
         # Draw pixel
         positions = [{x, y} | positions]

         # Correct error for next X
         error = error + delta_y

         # If error is at least 0, increment Y and correct error for next Y
         {y, error} =
           if error >= 0 do
             {y + y_step, error - delta_x}
           else
             {y, error}
           end

         {error, y, positions}
      end)
    positions
  end
end
