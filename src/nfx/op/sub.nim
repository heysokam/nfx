#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains code from lbartoletti/fpn (MIT)            :
#  Check the doc/licenses folder for more info about its license :
#:________________________________________________________________


# Substraction
proc isUnderflowSub *(a, b :SomeInteger) :bool=
  ## Returns true if `a` - `b` produces an underflow error
  b > 0 and a < low(typeof(a)) + b

proc isOverflowSub *(a, b :SomeInteger) :bool=
  ## Returns true if `a` - `b` produces an overflow error
  b < 0 and a > high(typeof(a)) + b

proc isSafeSub *(a, b :SomeInteger) :bool=
  ## Returns true if `a` - `b` is safe (no under- or overflow error)
  not isUnderflowSub(a, b) and not isOverflowSub(a, b)

proc ovSub *(a, b :SomeInteger) :SomeInteger=
  var pb = b
  result = a
  while pb != 0:
    var borrow = (not result) and pb
    result = result xor pb
    pb = borrow shl 1

