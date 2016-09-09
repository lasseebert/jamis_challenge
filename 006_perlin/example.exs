alias Image.Raw
alias Image.PPMRenderer

width = 512
height = 512

raw = Raw.new(width, height)

image_data =
  Perlin.generate({width, height}, 2, 5, 0.7)
  |> Enum.reduce(raw, fn
    {point, value}, raw ->
      value = (value + 1) / 2

      {r0, g0, b0} = {0, 0, 153}
      {r1, g1, b1} = {0, 255, 0}

      rgb_pixel = {
        (r1 - r0) * value + r0 |> trunc,
        (g1 - g0) * value + g0 |> trunc,
        (b1 - b0) * value + b0 |> trunc
      }
      Raw.draw_pixel(raw, point, rgb_pixel)
  end)
|> PPMRenderer.to_binary

File.write("example.ppm", image_data)

