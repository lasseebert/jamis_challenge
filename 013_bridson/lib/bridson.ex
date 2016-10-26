defmodule Bridson do
  @moduledoc """
  Generates Poisson disk sampling with Bridson's algorithm

  From the challenge text:

    The general idea, though is this:

    1. Place a point anywhere in the space you’re wanting to sample. Add it to the list of active samples.
    2. Choose a point at random from the list of active samples.
    3. Generate up to some number (k) potential samples between r and 2r distance from the current sample. Discard any that are closer than r to any other sample.
    4. If none of the potential samples are viable, remove the current sample from the active samples.
    5. Otherwise, add one of the potential samples to the active samples.
    6. If there are no more active samples, the algorithm terminates. Otherwise, repeat from #2.

    For normal mode (and one point), here’s all you’ve got to do:

    1. Generate an image of at least 256x256 pixels.
    2. Sample the image using Bridson’s algorithm for Poisson disk sampling, drawing a red dot at each sample’s position.
    3. The values k (the number of potential samples at each point) and r (the minimum distance separating each sample) ought to be configurable.
  """

  def generate({width, height} = dimensions, r, k) do
    points = [random_start_point(width, height)]
    active = points

    run(dimensions, r, k, points, active)
  end

  defp run(_dim, _r, _k, points, []) do
    points
  end
  defp run(dim, r, k, points, active) do
    active_index = active |> length |> :rand.uniform |> (&(&1 - 1)).()
    case generate_point(dim, r, k, points, Enum.at(active, active_index)) do
      nil -> run(dim, r, k, points, List.delete_at(active, active_index))
      point -> run(dim, r, k, [point | points], [point | active])
    end
  end

  defp generate_point(_dim, _r, 0, _points, _origin) do
    nil
  end
  defp generate_point({w, h} = dim, r, k, points, {origin_x, origin_y} = origin) do
    # Rejection sampling. Pick a uniformly random point in a rectangle.
    # If it is not within r to 2 * r from point, try again
    min_x = [origin_x - 2 * r, 0] |> Enum.max
    max_x = [origin_x + 2 * r, w - 1] |> Enum.min
    min_y = [origin_y - 2 * r, 0] |> Enum.max
    max_y = [origin_y + 2 * r, h - 1] |> Enum.min

    point = {
      :rand.uniform(max_x - min_x + 1) + min_x - 1,
      :rand.uniform(max_y - min_y + 1) + min_y - 1
    }

    dist = distance(point, origin)

    cond do
      dist < r || dist > 2 * r ->
        generate_point(dim, r, k, points, origin)
      distance_ok?(point, points, r) ->
        point
      true ->
        generate_point(dim, r, k - 1, points, origin)
    end
  end

  defp distance_ok?(point, points, r) do
    points
    |> Enum.all?(fn comp -> distance(point, comp) >= r end)
  end

  defp distance({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end

  defp random_start_point(width, height) do
    {:rand.uniform(width) - 1, :rand.uniform(height) - 1}
  end
end
