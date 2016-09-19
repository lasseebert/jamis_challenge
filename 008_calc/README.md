# Calc

Solution for Weekly Programming Challenge #8 by Jamis Buck.

See: http://weblog.jamisbuck.org/2016/9/17/weekly-programming-challenge-8.html

A recursive descent parser that understands simple arithmetics, variables, a few
built in functions and custom functions.

All code examples below can be evaluated with `Calc.eval`

## Simple arithmetics

```
1 + 2 / 4
(1 + 2) / 4
# => 0.75
```

## Variables

```
a = 1
b = 2
a / b
# => 0.5
```

## Branching

A simple ternary operator can be used as an `if`. It considers `0` to be false and all other value to be true.

```
1 ? 2 : 3
# => 2
```

It only evaluates the part that is returned:

```
a = -10
a < 0 ? b = 1 : b = 0
b
# => 1
```

## Functions

Define functions with the `fun` keyword. Bacause functions _are_ fun!

`fun(x) { x + 1 }`

A function is just a value.
To Call a function, it must be assigned to a variable:

```
plus_one = fun(x) { x + 1 }
plus_one(5)
# => 6
```

The scope of the function does not pollute the outer scope:

```
b = 1
a = fun(x) {
  b = 2
  print(b)
  x + b
}
a(6)
print(b)

# Prints "2"
# Prints "1"
```

But the outer scope is copied to the function scope at invoke time, which allows
for recursive functions and higher order functions:

```
plus = fun(x) {
  fun(y) { x + y }
}
plus_one = plus(1)
plus_one(5)
# => 6

fact = fun(n) {
  n == 1
    ? 1
    : fact(n - 1) * n
}
fact(5)
# => 120
```

## Lists

There is a little support for lists:

* `[]` creates an empty list
* `unshift(list, n)` adds an item to the start of the list, returns the updated list
* `reverse(list)` reverses a list

```
count = fun(n) {
  do_count(1, n, [])
}

do_count = fun(next, max, acc) {
  next - 1 == max ?
    reverse(acc) :
    do_count(next + 1, max, unshift(acc, next))
}

count(10)
# => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

## Built-in functions

Are called like regular function.

Number functions:

* `cos(x)`
* `sin(x)`
* `sqrt(x)`

List functions:

* `unshift(list, n)`
* `reverse(list)`

Any data type:
* `print(x)`. Will print out the given argument and return the same argument. Good for debugging.

## Example

Example of a program that can find prime factors of a number:

```
factors = fun(n) {
  do_factors(n, 2, [])
}

do_factors = fun(n, i, acc) {
  sqrt(n) < i
    ?
      acc = unshift(acc, n)
      reverse(acc)
    :
      div = n / i
      div == floor(div) ?
        do_factors(n / i, i, unshift(acc, i)) :
        do_factors(n, i + 1, acc)
}

factors(6546546546)
# => [2, 3, 107, 149, 68437.0]
```
