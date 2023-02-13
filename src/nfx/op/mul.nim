#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains code from lbartoletti/fpn (MIT)            :
#  Check the doc/licenses folder for more info about its license :
#:________________________________________________________________
import std/math
from ./divd import count_int_divide


# Multiplication
proc isOverflowMul *(a, b :SomeInteger) :bool=
  ## Returns true if `a` *`b` produces an overflow error
  ( a > 0 and ( b > 0 and a > ( high(typeof(a)) div b ) ) ) or 
  ( a < 0 and ( b < 0 and b < (  low(typeof(a)) div a ) ) )

proc isUnderflowMul *(a, b :SomeInteger) :bool=
  ## Returns true if `a` *`b` produces an underflow error
  ( a > 0 and ( b < 0 and b < ( high(typeof(a)) div a ) ) ) or 
  ( a < 0 and ( b > 0 and b > ( high(typeof(a)) div a ) ) )

proc isSafeMul *(a, b :SomeInteger) :bool=
  ## Returns true if `a` * `b` is safe (no under- or overflow error)
  not isUnderflowMul(a, b) and not isOverflowMul(a, b)

proc karatsuba *(x, y :BiggestInt) :BiggestInt=
  ## Returns x*y, using Karatsuba algorithm
  if (x < 10 and y < 10):
    return x*y

  var n = max(count_int_divide(x), count_int_divide(y))
  var m = n div 2

  var div_factor = 10 ^ m
  var x_H = x div div_factor
  var x_L = x mod div_factor

  var y_H = y div div_factor
  var y_L = y mod div_factor

  var a = karatsuba(x_H, y_H)
  var d = karatsuba(x_L, y_L)
  var e = karatsuba(x_H + x_L, y_H + y_L) - a - d

  (a * (10 ^ (m * 2) ) + e * (10 ^ m) + d)

