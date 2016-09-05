alias Image.Raw
alias Image.PPMRenderer

raw = Raw.new(256, 256)

image_data =
  Perlin.generate({256, 256}, {10, 10})
  |> Enum.reduce(raw, fn
    {{x, y}, value}, raw ->
      value = (value + 1) / 2 * 255 |> trunc
      Raw.draw_pixel(raw, {x, y}, {value, value, value})
  end)
|> PPMRenderer.to_binary

File.write("example.ppm", image_data)

