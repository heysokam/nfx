# n*fx | Deterministic fixed point math for Nim

## Disclaimer
Determinism is top priority.
Even at the cost of performance or precision.

If you want lots of precision and peak performance, you should look somewhere else.
Arithmetic with this library is 100% slower than any float math operation of the same kind.
It might even be slower than other fixed point math libraries.
But the target result will always be the same.
If you find a case where this is not true, please fill a bug report.

By default, if final output value [over/under]flows, it will be saturated (aka clamped to the high/low value for the type).
This is wildly imprecise, but result will be the same everytime.

If you require avoiding [over/under]flow checks, there are some alternative operators for them.
