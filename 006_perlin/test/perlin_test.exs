defmodule PerlinTest do
  use ExUnit.Case

  test "creating some noise" do
    pixels = Perlin.generate({5, 5}, {1, 1})

    assert %{} = pixels
    assert Map.get(pixels, {2, 4}) <= 1
    assert Map.get(pixels, {2, 4}) >= -1
  end
end
