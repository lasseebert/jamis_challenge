defmodule Sock.Client.HTTPTest do
  use ExUnit.Case

  alias Sock.Client.HTTP

  describe "parse_uri" do
    test "parsing a valid URI" do
      uri = "http://lasseebert.dk/en"
      {protocol, host, port, path} = uri |> HTTP.parse_uri

      assert protocol == "http"
      assert host == "lasseebert.dk"
      assert port == 80
      assert path == "/en"
    end

    test "parsing an uri without path" do
      uri = "http://lasseebert.dk"
      {protocol, host, port, path} = uri |> HTTP.parse_uri

      assert protocol == "http"
      assert host == "lasseebert.dk"
      assert port == 80
      assert path == "/"
    end

    test "parsing an uri with custom port" do
      uri = "http://lasseebert.dk:8080/en"
      {protocol, host, port, path} = uri |> HTTP.parse_uri

      assert protocol == "http"
      assert host == "lasseebert.dk"
      assert port == 8080
      assert path == "/en"
    end
  end

  test "GETting a resource" do
    response = HTTP.get("http://lasseebert.dk/en")

    assert response.status == 200
    assert response.headers |> Map.get("Content-Type") |> String.match?(~r{^text/html})
    assert response.body |> String.match?(~r/<html/)
  end
end
