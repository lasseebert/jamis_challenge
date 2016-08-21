defmodule Image.CanvasTest do
  use ExUnit.Case

  alias Image.Canvas
  alias Image.Raw

  test "drawing a line in first octant" do
    image =
      Raw.new(11, 5)
      |> Canvas.draw_line({0, 0}, {10, 4})

    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {4, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {5, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {6, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {7, 3}) == {0, 0, 0}
    assert Raw.pixel_at(image, {8, 3}) == {0, 0, 0}
    assert Raw.pixel_at(image, {9, 4}) == {0, 0, 0}
    assert Raw.pixel_at(image, {10, 4}) == {0, 0, 0}

    assert Raw.pixel_at(image, {0, 1}) == {255, 255, 255}
    assert Raw.pixel_at(image, {1, 1}) == {255, 255, 255}
    assert Raw.pixel_at(image, {2, 2}) == {255, 255, 255}
    assert Raw.pixel_at(image, {3, 2}) == {255, 255, 255}
    assert Raw.pixel_at(image, {4, 3}) == {255, 255, 255}
    assert Raw.pixel_at(image, {5, 3}) == {255, 255, 255}
    assert Raw.pixel_at(image, {6, 3}) == {255, 255, 255}
    assert Raw.pixel_at(image, {7, 4}) == {255, 255, 255}
    assert Raw.pixel_at(image, {8, 4}) == {255, 255, 255}
    assert Raw.pixel_at(image, {9, 3}) == {255, 255, 255}
    assert Raw.pixel_at(image, {10, 3}) == {255, 255, 255}
  end

  test "drawing a line in octant 1" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 0}, {3, 1})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 1}) == {0, 0, 0}
  end

  test "drawing a line in octant 2" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 0}, {1, 3})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 3}) == {0, 0, 0}
  end

  test "drawing a line in octant 3" do
    image = Raw.new(4, 4) |> Canvas.draw_line({1, 0}, {0, 3})
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 3}) == {0, 0, 0}
  end

  test "drawing a line in octant 4" do
    image = Raw.new(4, 4) |> Canvas.draw_line({3, 0}, {0, 1})
    assert Raw.pixel_at(image, {0, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 0}) == {0, 0, 0}
  end

  test "drawing a line in octant 5" do
    image = Raw.new(4, 4) |> Canvas.draw_line({3, 1}, {0, 0})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 1}) == {0, 0, 0}
  end

  test "drawing a line in octant 6" do
    image = Raw.new(4, 4) |> Canvas.draw_line({1, 3}, {0, 0})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 3}) == {0, 0, 0}
  end

  test "drawing a line in octant 7" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 3}, {1, 0})
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 3}) == {0, 0, 0}
  end

  test "drawing a line in octant 8" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 1}, {3, 0})
    assert Raw.pixel_at(image, {0, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 0}) == {0, 0, 0}
  end

  test "drawing a vertical line" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 0}, {0, 3})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 1}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 2}) == {0, 0, 0}
    assert Raw.pixel_at(image, {0, 3}) == {0, 0, 0}
  end

  test "drawing a horizontal line" do
    image = Raw.new(4, 4) |> Canvas.draw_line({0, 0}, {3, 0})
    assert Raw.pixel_at(image, {0, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {1, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {2, 0}) == {0, 0, 0}
    assert Raw.pixel_at(image, {3, 0}) == {0, 0, 0}
  end
end
