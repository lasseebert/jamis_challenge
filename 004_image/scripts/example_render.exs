defmodule ExampleRender do
  @moduledoc """
  Examples for the project

  Usage:

      mix run scripts/example_render.exs

  Then open the example.ppm output file or convert it with ImageMagick

      convert example.ppm example.png
  """

  alias Image.Canvas
  alias Image.PPMRenderer
  alias Image.Raw

  @doc "Draws a red box"
  def example_1 do
    data = Raw.new(200, 200)
            |> Canvas.draw_line({50, 150}, {50, 50}, {255, 0, 0})
            |> Canvas.draw_line({50, 50}, {150, 50}, {255, 0, 0})
            |> Canvas.draw_line({150, 50}, {150, 150}, {255, 0, 0})
            |> Canvas.draw_line({150, 150}, {50, 150}, {255, 0, 0})
            |> PPMRenderer.to_binary
    File.write!("example.ppm", data)
  end

  @doc "Draws a nice shape in four colors"
  def example_2 do
    x_max = 1800
    y_max = 1200
    steps = 100

    raw = Raw.new(x_max + 1, y_max + 1)

    raw = Enum.reduce(0..steps, raw, fn i, raw ->
      x_step = (x_max / steps) * i |> round
      y_step = (y_max / steps) * i |> round
      raw
      |> Canvas.draw_line({0, y_step}, {x_step, y_max}, {255, 0, 0})
      |> Canvas.draw_line({x_step, y_max}, {x_max, y_max - y_step}, {0, 255, 0})
      |> Canvas.draw_line({x_max, y_max - y_step}, {x_max - x_step, 0}, {0, 0, 255})
      |> Canvas.draw_line({x_max - x_step, 0}, {0, y_step}, {0, 255, 255})
    end)

    data = PPMRenderer.to_binary(raw)
    File.write!("example.ppm", data)
  end
end

ExampleRender.example_2
