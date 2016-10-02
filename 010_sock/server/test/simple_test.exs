defmodule Sock.Server.SimpleTest do
  use ExUnit.Case

  test "connecting to the simple server" do
    {:ok, socket} = :gen_tcp.connect('localhost', 1234, [:binary, active: :false])
    {:ok, "ready\n"} = :gen_tcp.recv(socket, 6)

    query = "fact = fun(n) { n == 1 ? 1 : fact(n - 1) * n }; fact(5)"
    payload = << query |> byte_size :: size(32), query::binary >>

    :ok = :gen_tcp.send(socket, payload)

    {:ok, <<response_size :: size(32)>>} = :gen_tcp.recv(socket, 4)
    {:ok, response} = :gen_tcp.recv(socket, response_size)

    assert response == "120"
  end
end
