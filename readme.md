# n*fx | Deterministic fixed point math for Nim


## Notes
Usually, in general fixed point math, the `fixed` part means specifically `decimal point fixed-to-a-bit math`.  

That means that the decimal point is fixed to a specific **bit** of the underlying integer.  
Something like `0b_0011_0101.0000`  

This library uses a fixed point in its **base10** (aka decimal) representation, no matter what the underlying bits are doing. Such that `42_000'int` == `42.000'f`. The underlying number would be storing a value of `42000`, which is 42 thousands.

In bit-usage-optimization terms, this is very inefficient.
We could be representing bigger numbers with the full 32bit range of an int32.  
But the `Fx` number type is created specifically for **determinism** in the context of a videogame engine.  
A use-case in which such gigantic sizes are not required at all.  

And if they were, they could use a `BigNumbers` type representation for overflow control of its underlying multiplications.
In that way, it would be possible represent its range of values inside an int64,
without overflowing it during karatsuba multiplications or other operations,
and therefore increase the maximum size of the world to even bigger sizes than what 32bits allow.  

### Disclaimer: Overview
Conversion from and to this library is more expensive than usual.  
The Fx type is meant to exist by itself in its own world of operations.  
If you want lots of precision and peak performance, you should look somewhere else.  
Determinism is #1 priority.

### Disclaimer: Explanation
Determinism is top priority.  
Even at the cost of performance or precision.  

If you want lots of precision and peak performance, you should look somewhere else.  
Arithmetic with this library is 100% slower than any float math operation of the same kind.  
It might even be slower than other fixed point math libraries.  
But the target result will always be the same.  
If you find a case where this is not true, please fill a bug report.  

Conversion from and to this library is much more expensive than usual.  
This is because the types must be divided, multiplied and/or truncated to get their accurate values.  
The Fx type is meant to exist by itself in its own world of operations.  
Only convert back and forth if you -really- need to use a different representation.  

By default, if final output value [over/under]flows, it will be saturated (aka clamped to the high/low value for the type).  
This is wildly imprecise under such cases, but result will be the same everytime.  

If you require avoiding [over/under]flow checks, there are some alternative operators for them.  
