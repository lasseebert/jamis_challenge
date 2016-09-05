alias Image.Raw
alias Image.PPMRenderer

width = 512
height = 512

raw = Raw.new(width, height)

image_data =
  Perlin.generate({width, height})
  |> Enum.reduce(raw, fn
    {{x, y}, value}, raw ->
      value = (value + 1) / 2 * 255 |> trunc
      Raw.draw_pixel(raw, {x, y}, {value, value, value})
  end)
|> PPMRenderer.to_binary

File.write("example.ppm", image_data)

