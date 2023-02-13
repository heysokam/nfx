#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains code from lbartoletti/fpn (MIT)            :
#  Check the doc/licenses folder for more info about its license :
#:________________________________________________________________

# abs
proc isSafeAbs *(a :SomeInteger) :bool=  a != low(typeof(a))
  ## Returns true if is safe to return the absolute value of `a`
  ##
  ## On signed integers abs(`a`) is safe only if a is not low(`a`)
  ##
  ## Example:
  ##
  ## .. code-block:: nim
  ##
  ##    var a = low(int16)
  ##    echo a ## -32768
  ##    echo isSafeAbs(a) ## false
  ##    echo abs(a) ## OverflowError


# Negate
proc isSafeNegate *(a: SomeInteger) :bool=  a != low(typeof(a))
  ## Returns true if is safe to return the negative value of `a`
  ##
  ## On signed integers -`a` is safe only if a is not low(`a`)
  ##
  ## See also:
  ##  * `isSafeAbs proc <#isSafeAbs,SomeInteger>`_
  ##
  ## Example:
  ##
  ## .. code-block:: nim
  ##
  ##    var a = low(int16)
  ##    echo a ## -32768
  ##    echo isSafeNegate(a) ## false
  ##    echo -a ## OverflowError


