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
