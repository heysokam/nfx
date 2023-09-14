 TRIG.TODO: https://www.youtube.com/watch?v=kkMt4lrJzs8
OPTIM.TODO: https://www.youtube.com/watch?v=gCzOhZ_LUps

## nfx notes
Check [std/bigints](https://nimdocs.com/nim-lang/bigints/bigints.html) compatibility with borrow and distinct
[Other functions](https://github.com/MikeLankamp/fpm/blob/master/include/fpm/math.hpp) not covered by fpn:

## Math operations  ( for conversions )
```c
// (x<<N) == x*2^N
((x << 2) + x) << 1  // Here 10*x is computed as (x*2^2 + x)*2
 (x << 3) +(x << 1)  // Here 10*x is computed as  x*2^3 + x*2
// In some cases such sequences of shifts and adds or subtracts will outperform hardware multipliers and especially dividers.
// A division by a number of the form 2^N or 2^N±1 can often be converted to such a short sequence.
```

## Align to 4
s:
A writeBuffer operation must copy a number of bytes that is a multiple of 4. To ensure so we can switch bufferDesc.size for (bufferDesc.size + 3) & ~4.
Trying to understand this statement

How is +3) & ~4 creating a multiple of 4?
I understand that it is adding 3 (dont know why)
and then &ing it with a number that is all 1s except for the last 4?  (is this correct? might not be)

How does all of this create a multiple of 4 at all? 

n: (number + (align-1)) & ~(align-1)  assuming align is power of two will align number to the next align boundary, if its not aligned
 : there is a bug then the quote you linked. It should be +3) & ~3 also it is a good idea to cast the numbers to the correct types so you dont end up with a truncated align mask. (edited)
s: kk, ty. how does it work, though? how does that bitwise math create multiples of the align number?
 : align must be a power of two, therefore It has only one bit set. align - 1  will make all the bits below it set.
Adding it to number means, if number is already aligned, it will fill out the bits below alignment, if its not aligned, it will move it over the next align boundary and maybe some bits will be set.
~(align-1) will invert the bits, creating a mask that can be used to cut off bits below alignment.
 : & will mask out the lower bits aligning the result
s: i see. makes a bit more sense now
