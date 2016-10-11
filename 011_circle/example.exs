defmodule Example do
  def one_red_circle do
    image =
      Image.Raw.new(400, 400, {180, 180, 180})
      |> Circle.draw_circle({150, 150}, 100, {255, 0, 0})
      |> Image.PPMRenderer.to_binary

    File.write!("example.ppm", image)
  end

  def many_circles do
    raw = Image.Raw.new(400, 400, {255, 255, 255})

    image =
      Stream.unfold(20, fn
        0 -> nil
        n ->
          origin = {100..299 |> Enum.random, 100..299 |> Enum.random}
          radius = 20..100 |> Enum.random
          color = {0..255 |> Enum.random, 0..255 |> Enum.random, 0..255 |> Enum.random}
          {{origin, radius, color}, n - 1}
      end)
      |> Enum.reduce(raw, fn {origin, radius, color}, raw ->
        Circle.draw_circle(raw, origin, radius, color)
      end)
      |> Image.PPMRenderer.to_binary

    File.write!("example.ppm", image)
  end
end

case System.argv do
  ["one_red_circle"] -> Example.one_red_circle
  ["many_circles"] -> Example.many_circles
  _ -> IO.puts("Invalid arguments")
end
