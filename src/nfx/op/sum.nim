#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains code from lbartoletti/fpn (MIT)            :
#  Check the doc/licenses folder for more info about its license :
#:________________________________________________________________


# Addition
proc isUnderflowAdd *(a, b :SomeInteger) :bool=
  ## Returns true if `a` + `b` produces an underflow error
  b < 0 and a < low(typeof(a)) - b

proc isOverflowAdd *(a, b :SomeInteger) :bool=
  ## Returns true if `a` + `b` produces an overflow error
  b > 0 and a > high(typeof(a)) - b

proc isSafeAdd *(a, b :SomeInteger) :bool=
  ## Returns true if `a` + `b` is safe (no under- or overflow error)
  not isUnderflowAdd(a, b) and not isOverflowAdd(a, b)

proc ovAdd *(a, b :SomeInteger) :SomeInteger=
  var pb = b
  result = a
  while pb != 0:
      var carry = result and pb
      result = result xor pb
      pb = carry shl 1

