#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains code from lbartoletti/fpn (MIT)            :
#  Check the doc/licenses folder for more info about its license :
#:________________________________________________________________

# Division
proc count_int_divide *(x :SomeInteger) :SomeInteger=
  ## Divides a number by 10, itself times, until the integer part is 0.
  ## Returns the amount of times that a division has occurred.
  ## Used in Karatsuba for the divide-and-conquer part.
  var n = x
  while ( n != 0 ):
    result += 1
    n = n div 10

proc isOverflowDiv *(a, b :SomeInteger) :bool=
  ## Returns true if `a` / `b` produces an overflow error
  (a == low(typeof(a)) and b == -1)

proc isUnderflowDiv *(a, b :SomeInteger) :bool=  false
  ## A division can never go underflow. Always returns false.
  # Returns true if `a` / `b` produces an underflow error...
  # Wait... no. Returns false

proc isSafeDiv *(a, b :SomeInteger) :bool=
  ## Returns true if `a` / `b` is safe (no under- or overflow error) and b != 0
  b != 0 and not isOverflowDiv(a, b)

