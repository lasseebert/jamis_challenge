defmodule Sock.Client.Socket do
  @moduledoc """
  A wrapper around :gen_tcp
  """

  defstruct(
    socket: nil,
    data: ""
  )

  @lineend_pattern ~r/\r\n?/

  def connect(host, port) do
    # Erlang syntax for host name
    socket_host = host |> String.to_char_list

    {:ok, socket} = :gen_tcp.connect(socket_host, port, [:binary, active: :false])

    %__MODULE__{socket: socket}
  end

  def send(socket, message) do
    :gen_tcp.send(socket.socket, message)
  end

  def receive_line(socket, timeout) do
    if socket.data |> String.match?(@lineend_pattern) do
      [line, data] = String.split(socket.data, @lineend_pattern, parts: 2)
      {line, %{socket | data: data}}
    else
      receive_data(socket, timeout)
      |> receive_line(timeout)
    end
  end

  def receive_bytes(socket, count, timeout) do
    if socket.data |> byte_size >= count do
      <<result::binary-size(count), data::binary>> = socket.data
      {result, %{socket | data: data}}
    else
      receive_data(socket, timeout)
      |> receive_bytes(count, timeout)
    end
  end

  defp receive_data(socket, timeout) do
    {:ok, data} = :gen_tcp.recv(socket.socket, 0, timeout)
    %{socket | data: socket.data <> data}
  end
end
