# Image

Solution for Weekly Programming Challenge #4 by Jamis Buck.

See: https://medium.com/@jamis/weekly-programming-challenge-4-7fe42f28d5d4

Usage:

Use `Raw` to initialize a new raw image and use `Canvas` to draw on the raw
image with straight lines.
Finally, use `PPMRenderer` to render the image to a ppm file.

Example:

```elixir
alias Image.Canvas
alias Image.PPMRenderer
alias Image.Raw

x_max = 300
y_max = 200
steps = 50

raw = Raw.new(x_max + 1, y_max + 1)

raw = Enum.reduce(0..steps, raw, fn i, raw ->
  x_step = (x_max / steps) * i |> round
  y_step = (y_max / steps) * i |> round
  raw
  |> Canvas.draw_line({0, y_step}, {x_step, y_max}, {255, 0, 0})
  |> Canvas.draw_line({x_step, y_max}, {x_max, y_max - y_step}, {0, 255, 0})
  |> Canvas.draw_line({x_max, y_max - y_step}, {x_max - x_step, 0}, {0, 0, 255})
  |> Canvas.draw_line({x_max - x_step, 0}, {0, y_step}, {0, 255, 255})
end)

data = PPMRenderer.to_binary(raw)
File.write!("example.ppm", data)
```

Will yield:

![Example image](https://raw.githubusercontent.com/lasseebert/jamis_challenge/master/004_image/example.png)
