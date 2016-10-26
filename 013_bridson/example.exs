defmodule Example do
  def default do
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
  end
end

Example.default
