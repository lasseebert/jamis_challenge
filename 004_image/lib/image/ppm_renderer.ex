defmodule Image.PPMRenderer do
  @moduledoc """
  Converts a Raw image to ppm data
  """

  alias Image.Raw

  def to_binary(%Raw{} = raw) do
    header = "P6\n#{Raw.width(raw)} #{Raw.height(raw)}\n255\n"
    pixel_data =
      for y <- 0..Raw.height(raw) - 1,
          x <- 0..Raw.width(raw) - 1 do
            {r, g, b} = Raw.pixel_at(raw, {x, y})
            <<r, g, b>>
          end
      |> Enum.join

    header <> pixel_data
  end
end
