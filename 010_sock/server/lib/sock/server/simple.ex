defmodule Sock.Server.Simple do
  @moduledoc """
  The Normal mode solution. This is a simple request-response server.

  For the sake of example, we use the Calc interpreter from week 8.
  """

  def start_link(port: port) do
    Task.start_link(fn ->
      opts = [:binary, active: false, reuseaddr: true]
      {:ok, listen_socket} = :gen_tcp.listen(port, opts)
      listen(listen_socket)
    end)
  end

  defp listen(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    handle_client(socket)
    listen(listen_socket)
  end

  defp handle_client(socket) do
    :gen_tcp.send(socket, "ready\n")

    {:ok, <<query_size :: size(32)>>} = :gen_tcp.recv(socket, 4)
    {:ok, query} = :gen_tcp.recv(socket, query_size)

    result = Calc.eval(query) |> inspect
    :ok = :gen_tcp.send(socket, <<result |> byte_size :: size(32), result::binary>>)
    :gen_tcp.close(socket)
  end
end
