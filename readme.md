# Fixed Point Math
Floating point numbers are pretty great. They let you represent a wide range of numbers. But they are not always consistent across cpus. This is usually fine, but there are sometimes cases where you need your code to behave exactly the same on all systems. I ran into a need for this, and decided to make it a small library.

This library adds a `FixedPointNumber` abstract over Haxe's `Int64` that uses the last 16 bits of the number as decimal places.

In many cases, using fixed point numbers instead of floats is as simple as changing the type of the expression. For example
```hx
var number:FixedPointNumber = 1.5```

Note that this abstract *will* get implicitly casted to and from `Int`, `Float`, and `Int64`. When a cast *to* FixedPointNumber occurs, the value of the number is converted correctly to a fixed point number.

i will write this readme more later maybe
