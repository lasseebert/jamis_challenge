defmodule Sock.Client.Socket do
  @moduledoc """
  A wrapper around :gen_tcp.

  It saves the received data and receives more when needed.
  This makes it easy to get data line by line and as raw binary data with the same socket.
  """

  defstruct(
    socket: nil,
    data: ""
  )

  @lineend_pattern ~r/\r\n?/

  @doc """
  Creates a new socket to the given destination
  """
  def connect(host, port) do
    # Erlang syntax for host name
    socket_host = host |> String.to_char_list

    {:ok, socket} = :gen_tcp.connect(socket_host, port, [:binary, active: :false])

    %__MODULE__{socket: socket}
  end

  @doc """
  Closes the socket
  """
  def close(socket) do
    :gen_tcp.close(socket.socket)
    socket
  end

  @doc """
  Sends the payload
  """
  def send(socket, payload) do
    :gen_tcp.send(socket.socket, payload)
  end

  @doc """
  Receives a single line of data. Lines end with a \r and optionally also with a \n
  Returns the received line and the updated socket struct
  """
  def receive_line(socket, timeout) do
    if socket.data |> String.match?(@lineend_pattern) do
      [line, data] = String.split(socket.data, @lineend_pattern, parts: 2)
      {line, %{socket | data: data}}
    else
      receive_data(socket, timeout)
      |> receive_line(timeout)
    end
  end

  @doc """
  Receives a specified amount of bytes.
  """
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
