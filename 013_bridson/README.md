# Bridson

Solution for Weekly Programming Challenge #13 by Jamis Buck.

See:
http://weblog.jamisbuck.org/2016/10/22/weekly-programming-challenge-13.html

## Poisson disk sampling

Usage

To generate poisson disk samples with Bridson's algorithm using an image of 256x256 pixels, r=10, k=5:

```elixir
iex> Bridson.generate({256, 256}, 10, 5)
[{1, 10}, {53, 13}, {6, 1}, {24, 0}, {44, 3}, {7, 231}, {12, 12}, {69, 2},
 {1, 92}, {3, 246}, {43, 15}, {30, 213}, {33, 242}, {2, 204}, {54, 1},
 {57, 253}, {5, 24}, {3, 34}, {217, 13}, {26, 190}, {16, 254}, {0, 44}, {98, 0},
 {84, 0}, {13, 35}, {241, 0}, {21, 208}, {33, 254}, {123, 0}, {22, 21},
 {12, 221}, {191, 0}, {8, 187}, {11, 197}, {8, 80}, {25, 222}, {35, 70},
 {36, 91}, {14, 46}, {42, 221}, {31, 10}, {32, 41}, {206, 16}, {1, 71}, {1, 61},
 {4, 118}, {20, 238}, {77, 11}, {250, ...}, {...}, ...]
```

Example on how to plot it using the image library from
[week 4](https://github.com/lasseebert/jamis_challenge/tree/master/004_image) and the circle library from
[week 11](https://github.com/lasseebert/jamis_challenge/tree/master/011_circle):

```elixir
background_color = {180, 180, 180}
color = {255, 0, 0}
r = 16
k = 10
draw_radius = 8

image = Image.Raw.new(256, 256, background_color)
points = Bridson.generate({256, 256}, r, k)
data =
  points
  |> Enum.reduce(image, fn point, image -> Circle.draw_circle(image, point, draw_radius, color) end)
  |> Image.PPMRenderer.to_binary

File.write!("example.ppm", data)
```

Will give this:

![Example image](https://raw.githubusercontent.com/lasseebert/jamis_challenge/master/013_bridson/example.png)
