defmodule CircleTest do
  use ExUnit.Case

  test "drawing a small circle" do
    white = {255, 255, 255}
    black = {0, 0, 0}

    image = Image.Raw.new(5, 5, white)
            |> Circle.draw_circle({2, 2}, 2, black)

    assert image |> Image.Raw.pixel_at({0, 0}) == white
    assert image |> Image.Raw.pixel_at({1, 0}) == white
    assert image |> Image.Raw.pixel_at({2, 0}) == black
    assert image |> Image.Raw.pixel_at({3, 0}) == white
    assert image |> Image.Raw.pixel_at({4, 0}) == white

    assert image |> Image.Raw.pixel_at({0, 1}) == white
    assert image |> Image.Raw.pixel_at({1, 1}) == black
    assert image |> Image.Raw.pixel_at({2, 1}) == white
    assert image |> Image.Raw.pixel_at({3, 1}) == black
    assert image |> Image.Raw.pixel_at({4, 1}) == white
  end
end
