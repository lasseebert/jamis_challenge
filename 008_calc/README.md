# Calc

Solution for Weekly Programming Challenge #8 by Jamis Buck.

See: http://weblog.jamisbuck.org/2016/9/17/weekly-programming-challenge-8.html

A recursive descent parser that understands simple arithmetics, variables, a few
built in functions and custom functions.

Examples:

```elixir
# Simple
Calc.eval("1 + 2")
# returns 3

# Parenthesis
Calc.eval("(1 + 2) * 3")
# returns 9

# Variables
Calc.eval("a = 1; b = 2; a + b")
# returns 3

# Functions
Calc.eval("square = fun(x) { x * x }; square(5)")
# returns 25

# Local scope
Calc.eval("a = 1; myfun = fun() { a = 2; a }; myfun(); a")
# returns 1

# Functions as argument to other functions
Calc.eval("a = fun(x) { x + 1 }; b = fun(f, x) { f(x) + 2 }; b(a, 3)")
# returns 6

# Function binds to local scope at definition allowing for higher order functions
Calc.eval("plus = fun(x) { fun(y) { y + x } }; plustwo = plus(2); plustwo(5)")
# returns 7

# Built in functions
Calc.eval("cos(sin(3/2))")
# returns 0.5424085045303605
```

Stuff I would like to add:

* Create empty list, push to list: `count = fun(list, n) { n ? count(push(list, n), n - 1) : list }; count([], 5) # => [5, 4, 3, 2, 1]`
* Default argument values: `a = fun(b = 1, c = 2) { b + c }; a(5) # => 7`
