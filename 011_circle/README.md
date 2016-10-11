# Circle

Solution for Weekly Programming Challenge #11 by Jamis Buck.

See:
http://weblog.jamisbuck.org/2016/10/8/weekly-programming-challenge-11.html

Usage:

```elixir
image =
  Image.Raw.new(400, 400, {255, 255, 255})
  |> Circle.draw_circle({150, 150}, 100, {255, 0, 0})
  |> Image.PPMRenderer.to_binary

File.write!("example.ppm", image)
```

![Example image](https://raw.githubusercontent.com/lasseebert/jamis_challenge/master/011_circle/example.png)
