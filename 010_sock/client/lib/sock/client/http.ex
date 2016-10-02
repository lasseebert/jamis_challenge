defmodule Sock.Client.HTTP do
  @moduledoc """
  A very basic HTTP client

  It supports most basic features of HTTP/1.1
  """

  alias Sock.Client.Response
  alias Sock.Client.Socket

  @uri_pattern ~r{^(?<protocol>[^:]+)://(?<host>[^/:]+)(:(?<port>\d+))?(?<path>.*)}
  @default_port 80
  @request_timeout 5000
  @line_ending "\r\n"

  @doc """
  GETs the specified resource
  """
  def get(uri) do
    {protocol, host, port, path} = uri |> parse_uri
    transmit("GET", protocol, host, port, path)
  end

  @doc """
  Parses a uri into protocol, host, port and path parts
  """
  def parse_uri(uri) do
    groups = Regex.named_captures(@uri_pattern, uri)
    protocol = groups |> Map.get("protocol")
    host = groups |> Map.get("host")
    port = groups |> Map.get("port")
    path = groups |> Map.get("path")

    port = case port do
      "" -> @default_port
      port -> port |> String.to_integer
    end

    path = case path do
      "" -> "/"
      path -> path
    end

    {protocol, host, port, path}
  end

  defp transmit("GET", "http", host, port, path) do
    socket = Socket.connect(host, port)

    headers = %{
      "Host" => host,
      "Connection" => "close"
    }
    request = build_request("GET", path, headers)
    :ok = Socket.send(socket, request)

    {socket, response} =
      {socket, %Response{}}
      |> read_headers
      |> read_body

    Socket.close(socket)
    response
  end

  defp read_headers({socket, response}) do
    case Socket.receive_line(socket, @request_timeout) do
      {"", socket} ->
        {socket, response}
      {line, socket} ->
        {socket, parse_response_header(response, line)}
        |> read_headers
    end
  end

  defp read_body({socket, response}) do
    case Response.content_length(response) do
      0 ->
        {socket, response}
      n ->
        {body, socket} = Socket.receive_bytes(socket, n, @request_timeout)
        {socket, %{response | body: body}}
    end
  end

  defp build_request(method, path, headers) do
    initial = "#{method} #{path} HTTP/1.1#{@line_ending}"
    headers
    |> Enum.reduce(initial, fn {name, value}, acc ->
      acc <> "#{name}: #{value}#{@line_ending}"
    end)
    |> Kernel.<>(@line_ending)
  end

  defp parse_response_header(response, "HTTP/1.1 " <> status) do
    %{response | status: parse_status(status)}
  end
  defp parse_response_header(response, line) do
    [name, value] =
      line
      |> String.split(":", parts: 2)
      |> Enum.map(&String.trim/1)

    headers =
      response.headers
      |> Map.put(name, value)

    %{response | headers: headers}
  end

  defp parse_status(status_line) do
    Regex.named_captures(~r/^(?<status>\d+)/, status_line)
    |> Map.get("status")
    |> String.to_integer
  end
end
