defmodule Image.RawTest do
  use ExUnit.Case

  alias Image.Raw

  test "initializing with a background color" do
    raw = Raw.new(3, 4, {255, 0, 0})

    assert Raw.pixel_at(raw, {1, 2}) == {255, 0, 0}
    assert Raw.width(raw) == 3
    assert Raw.height(raw) == 4
  end

  test "setting a pixel" do
    raw =
      Raw.new(3, 4, {255, 0, 0})
      |> Raw.draw_pixel({1, 2}, {0, 255, 0})


    assert Raw.pixel_at(raw, {1, 2}) == {0, 255, 0}
  end
end
