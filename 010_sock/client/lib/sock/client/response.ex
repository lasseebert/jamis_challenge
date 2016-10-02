defmodule Sock.Client.Response do
  @moduledoc """
  Response struct
  """

  defstruct(
    status: 0,
    headers: %{},
    body: ""
  )

  def content_length(response) do
    case Map.get(response.headers, "Content-Length") do
      nil -> 0
      value -> value |> String.to_integer
    end
  end
end
