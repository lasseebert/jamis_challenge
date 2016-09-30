# Bexier

Solution for Weekly Programming Challenge #9 by Jamis Buck.

See: http://weblog.jamisbuck.org/2016/9/24/weekly-programming-challenge-9.html

Can render a simple quadratic beizer curve using the PPM renderer from week 4

Usage:

```elixir
Bexier.Renderer.render({{50, 250}, {100, -150}, {450, 250}}, {500, 300}, "example.ppm")
```

Will render this image:

![Example image](https://raw.githubusercontent.com/lasseebert/jamis_challenge/master/009_bexier/example.png)
