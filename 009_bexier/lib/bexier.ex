defmodule Bexier do
  def quadratic({{x0, y0}, {x1, y1}, {x2, y2}}, t) do
    {
      quadratic_func(x0, x1, x2, t),
      quadratic_func(y0, y1, y2, t)
    }
  end

  defp quadratic_func(a, b, c, t) do
    a * (1 - t) * (1 - t) +
    b * 2 * (1 - t) * t +
    c * t * t
    |> round
  end
end
