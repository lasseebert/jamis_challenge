# Perlin

Solution for Weekly Programming Challenge #6 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-6-83fa37e9e737

Generates 2D Perlin noise, optionally with multiple octaves.

Example:

```elixir
Perlin.generate({512, 512}, 2, 5, 0.7)
```

The above will generate noise in a 512x512 image using octaves 2 to 5. Octave 1
is using a Perlin grid of size 1. For each octave the grid size doubles.

The `0.7` is the persistance, i.e. how much the amplitude is multiplied with for
each octave.

The above does not return an image, but just a value between -1 and 1 for each
pixel. To do something reasonable about it, one would have to interpret the
values in some color scale and render it to an image.

This is an example of using the PPM renderer from
[week 4](https://github.com/lasseebert/jamis_challenge/tree/master/004_image) to
render the image in a blue-green scale:

```elixir
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
```

Will yield:

![Example image](https://raw.githubusercontent.com/lasseebert/jamis_challenge/master/006_perlin/example.png)
