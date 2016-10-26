defmodule Circle do
  def draw_circle(raw, {origin_x, origin_y}, radius, color) do
    start_point = {radius, 0}
    error = 0

    draw_center_circle(start_point, error, MapSet.new)
    |> Enum.map(fn {x, y} -> {x + origin_x, y + origin_y} end)
    |> Enum.reduce(raw, fn {x, y} = pixel, raw ->
      if x >= 0 && x < raw.width && y >= 0 && y < raw.height do
        Image.Raw.draw_pixel(raw, pixel, color)
      else
        raw
      end
    end)
  end

  defp draw_center_circle({x, y}, _error, set) when x < y do
    set
  end
  defp draw_center_circle({x, y}, error, set) do
    set =
      set
      |> MapSet.put({x, y})
      |> MapSet.put({x, -y})
      |> MapSet.put({-x, y})
      |> MapSet.put({-x, -y})
      |> MapSet.put({y, x})
      |> MapSet.put({y, -x})
      |> MapSet.put({-y, x})
      |> MapSet.put({-y, -x})

    y = y + 1
    error = error + 1 + 2 * y

    {x, error} = if 2 * (error - x) + 1 > 0 do
      {x - 1, error - 1 - 2 * x}
    else
      {x, error}
    end

    draw_center_circle({x, y}, error, set)
  end

end
