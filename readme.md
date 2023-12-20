> **WARNING**: This repository has been archived as of _Dec.2023_  
> Feel free to fork it and update whatever you need.  
> See the [Reason for archival of this repository](#why-i-changed-pure-nim-to-be-my-auxiliary-programming-language-instead-of-being-my-primary-focus) section for an explanation of why this was decided.

> _Note: It **might** eventually be unarchived,_  
> _and become a Nim wrapper for the [MinC](https://github.com/heysokam/minc) library that will contain this exact same functionality._

# n*fx | Deterministic fixed point math for Nim

> **Bugs warning**:  
> There is a bug somewhere in the sine function that I never found the time to search for and fix.  
> The rest of the library works fine.  
> If you want fixed point numbers, but don't need the determinism specifically, I recommend using @[lbartoletti/fpn](https://gitlab.com/lbartoletti/fpn) instead.

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


---

### Why I changed Pure Nim to be my auxiliary programming language, instead of being my primary focus
> _Important:_  
> _This reason is very personal, and it is exclusively about using Nim in a manual-memory-management context._  
> _Nim is great as it is, and the GC performance is so optimized that it's barely noticeable that it is there._  
> _That's why I still think Nim is the best language for projects where a GC'ed workflow makes more sense._  

Nim with `--mm:none` was always my ideal language.  
But its clear that the GC:none feature (albeit niche) is only provided as a sidekick, and not really maintained as a core feature.  

I tried to get Nim to behave correctly with `--mm:none` for months and months.  
It takes an absurd amount of unnecessary effort to get it to a basic default state.  

And I'm not talking about the lack of GC removing half of the nim/std library because of nim's extensive use of seq/string in its stdlib.  
I'm talking about features that shouldn't even be allowed to exist at all in a gc:none context, because they leak memory and create untrackable bugs.  
_(eg: exceptions, object variants, dynamically allocated types, etc etc)_  

After all of that effort, and seeing how futile it was, I gave up on `--mm:none` completely.  
It would take a big amount of effort patching nim itself so that these issues are no longer there.  
And, sadly, based on experience, I'm not confident in my ability to communicate with Nim's leadership to do such work myself.  

This setback led me to consider other alternatives, including Zig or Pure C.  
But, in the end, I decided that from now on I will be programming with my [MinC](https://github.com/heysokam/minc) source-to-source language/compiler instead.  

As such, I will be deprecating most of my `n*dk` libraries.  
And I will be creating my engine's devkit with MinC instead.  

