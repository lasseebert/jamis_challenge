defmodule Sock.Client.Simple do
  @moduledoc """
  Client for Normal mode. Sends a request to the server and returns the response.
  """

  def request(query, port) do
    {:ok, socket} = :gen_tcp.connect('localhost', port, [:binary, active: :false])

    payload = << query |> byte_size :: size(32), query::binary >>

    with {:ok, "ready\n"} <- :gen_tcp.recv(socket, 6),
         :ok <- :gen_tcp.send(socket, payload),
         {:ok, <<response_size :: size(32)>>} <- :gen_tcp.recv(socket, 4),
         {:ok, response} <- :gen_tcp.recv(socket, response_size) do
           response
         end
  end
end
