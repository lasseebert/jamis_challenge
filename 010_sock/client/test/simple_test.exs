defmodule Sock.Client.SimpleTest do
  use ExUnit.Case
  alias Sock.Client.Simple

  def with_server(fun) do
    opts = [:binary, active: false, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(1234, opts)

    spawn_link(fn ->
      {:ok, socket} = :gen_tcp.accept(listen_socket)
      :gen_tcp.send(socket, "ready\n")

      {:ok, <<query_size :: size(32)>>} = :gen_tcp.recv(socket, 4)
      {:ok, query} = :gen_tcp.recv(socket, query_size)

      result = "#{query} -> response"
      :ok = :gen_tcp.send(socket, <<result |> byte_size :: size(32), result::binary>>)

      :gen_tcp.close(socket)
      :gen_tcp.close(listen_socket)
    end)

    fun.()
  end

  test "performaing a query" do
    with_server(fn ->
      query = "query"
      result = Simple.request(query, 1234)

      assert result == "query -> response"
    end)
  end
end
