defmodule Bexier.Renderer do
  alias Image.Canvas
  alias Image.PPMRenderer
  alias Image.Raw

  def render(points, {width, height}, file_name, step \\ 0.01) do
    raw =
      Raw.new(width, height)
      |> draw_lines(nil, points, 0, step)
    data = PPMRenderer.to_binary(raw)
    File.write!(file_name, data)
  end

  defp draw_lines(raw, nil, points, 0, step) do
    draw_lines(raw, Bexier.quadratic(points, 0), points, step, step)
  end
  defp draw_lines(raw, _origin, _points, t, _step) when t > 1 do
    raw
  end
  defp draw_lines(raw, origin, points, t, step) do
    point = Bexier.quadratic(points, t)
    raw = Canvas.draw_line(raw, origin, point)
    draw_lines(raw, point, points, t + step, step)
  end
end
