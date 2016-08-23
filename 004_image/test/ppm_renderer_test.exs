defmodule Image.PPMRendererTest do
  use ExUnit.Case

  alias Image.PPMRenderer
  alias Image.Raw

  test "rendering i small image" do
    raw =
      Raw.new(4, 4, {0, 0, 0})
      |> Raw.draw_pixel({0, 0}, {255, 0, 0})
      |> Raw.draw_pixel({1, 1}, {0, 255, 0})
      |> Raw.draw_pixel({2, 2}, {0, 0, 255})
      |> Raw.draw_pixel({3, 3}, {128, 128, 128})

    ppm = PPMRenderer.to_binary(raw)

    assert ppm == <<
      "P6\n4 4\n255\n",
      255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 128
    >>
  end
end
