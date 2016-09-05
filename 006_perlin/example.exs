alias Image.Raw
alias Image.PPMRenderer

width = 512
height = 512

raw = Raw.new(width, height)

image_data =
  Perlin.generate({width, height}, 2, 5, 0.7)
  |> Enum.reduce(raw, fn
    {{x, y}, value}, raw ->
      value = (value + 1) / 2

      r0 = 0
      g0 = 0
      b0 = 153

      r1 = 0
      g1 = 255
      b1 = 0

      r = (r1 - r0) * value + r0 |> trunc
      g = (g1 - g0) * value + g0 |> trunc
      b = (b1 - b0) * value + b0 |> trunc
      Raw.draw_pixel(raw, {x, y}, {r, g, b})
  end)
|> PPMRenderer.to_binary

File.write("example.ppm", image_data)

