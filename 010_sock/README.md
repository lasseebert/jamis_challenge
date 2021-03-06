# Sock

Solution for Weekly Programming Challenge #10 by Jamis Buck.

See: http://weblog.jamisbuck.org/2016/10/1/weekly-programming-challenge-10.html

## Normal mode solution

The server starts on a configured port (1234) and interprets the query as
[Calc](https://github.com/lasseebert/jamis_challenge/tree/master/008_calc) syntax.

The client can then be used to query the server.

Example:

```elixir
Sock.Client.Simple.request("fact = fun(n) { n == 1 ? 1 : fact(n - 1) * n }; fact(5)", 1234)
# => "120"
```

* [See server code](https://github.com/lasseebert/jamis_challenge/blob/master/010_sock/server/lib/sock/server/simple.ex)
* [See client code](https://github.com/lasseebert/jamis_challenge/blob/master/010_sock/client/lib/sock/client/simple.ex)


## HTTP client

The client is compatible with the most basic parts of HTTP/1.1.

It implements GET and returns a Response struct with status, headers and body.

Example:

```
alias Sock.client.HTTP

response = HTTP.get("http://lasseebert.dk/en")

response.status
# => 200

response.headers |> Map.get("Content-Type")
# => "text/html;charset=utf-8"

Regex.run(~r{<title>[^<]+</title>}, response.body)
# => ["<title>Lasse Ebert</title>"]
```

* [See client code](https://github.com/lasseebert/jamis_challenge/blob/master/010_sock/client/lib/sock/client/http.ex)
