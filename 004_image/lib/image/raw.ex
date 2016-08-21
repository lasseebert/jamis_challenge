defmodule Image.Raw do
  @moduledoc """
  Represents raw image data.

  A pixel is represented by its position {x, y} and its RGB color {r, g, b}
  """

  defstruct(
    width: 0,
    height: 0,
    pixels: %{}
  )

  def new(width, height, background_color \\ {255, 255, 255}) do
    pixels = for x <- (0..width-1),
        y <- (0..height-1) do
          {x, y}
        end
    |> Enum.reduce(%{}, fn position, pixels -> Map.put(pixels, position, background_color) end)

    % __MODULE__{width: width, height: height, pixels: pixels}
  end

  def draw_pixel(raw, position, color) do
    %{raw | pixels: Map.update!(raw.pixels, position, fn _ -> color end)}
  end

  def pixel_at(raw, position) do
    Map.fetch!(raw.pixels, position)
  end

  def width(%{width: width}), do: width
  def height(%{height: height}), do: height
end
