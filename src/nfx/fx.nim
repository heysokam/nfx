#:______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:______________________________________________
# std dependencies
import std/math
import std/strutils
import ./op

#_____________________________
# Type Definitions
#___________________
type FxBase  * = int32            ## Type used to store fixed point numbers
type Fx      * = distinct FxBase  ## FxBase fixed point number
type FxError * = object of ValueError

#_____________________________
# Configuration
#___________________
const FxPrecision  *:FxBase= 4                      ## Decimal places of precision
const FxResolution *:FxBase= FxBase(10^FxPrecision) ## Amount of steps represented per 1u

#_____________________________
# Constructors
#___________________
proc fx *(n :SomeInteger) :Fx=  Fx(n*FxResolution)
proc fx *(n :SomeFloat)   :Fx=  Fx(n*FxResolution.float)
template `'fx` *[T](n :T) :Fx=  fx(n)
# Getters
func whole  *(n :FxBase) :FxBase=    FxBase(n / FxResolution)
func whole  *(f1 :Fx)    :FxBase=    FxBase(f1.FxBase / FxResolution)
func frac   *(n :FxBase) :FxBase=    FxBase(n mod FxResolution)
func frac   *(f1 :Fx)    :FxBase=    FxBase(f1.FxBase mod FxResolution)
func fracFl *(f1 :Fx)    :SomeFloat= (f1.FxBase mod FxResolution)/FxResolution

#_____________________________
# Constants
#___________________
const Zero     *:Fx= 0.fx
const One      *:Fx= 1.fx
const Two      *:Fx= 2.fx
const Half     *:Fx= 0.5.fx
const High     *:Fx= FxBase.high.Fx
# FxBase Constants
const WholeMax *:FxBase= FxBase.high.whole  ## Filter for getting the whole part.
const FracMax  *:FxBase= FxBase.high.frac   ## Filter for getting the fractional part.

#_____________________________
# Borrowed from FxBase
#___________________
func `-`   *(fx :Fx)    :Fx {.borrow.}
func `+`   *(fx :Fx)    :Fx {.borrow.}
func `-`   *(f1,f2 :Fx) :Fx {.borrow.}
func `+`   *(f1,f2 :Fx) :Fx {.borrow.}
func `+=`  *(f1 :var Fx; f2 :Fx) {.borrow.}
func `-=`  *(f1 :var Fx; f2 :Fx) {.borrow.}
func `<`   *(f1,f2 :Fx) :bool {.borrow.}
func `<=`  *(f1,f2 :Fx) :bool {.borrow.}
func `==`  *(f1,f2 :Fx) :bool {.borrow.}
func min   *(f1,f2 :Fx) :Fx {.borrow.}
func max   *(f1,f2 :Fx) :Fx {.borrow.}
func `mod` *(f1,f2 :Fx) :Fx {.borrow.}
func `abs` *(f1 :Fx) :Fx {.borrow.}

#_____________________________
# Specific. Cannot borrow
#___________________
# Sign
proc sign *(v :Fx) :Fx=  # modified from vmath to fit the type correctly
  ## Returns the sign of the Fx number, -1 or 1.
  if v >= Zero: One else: -One
#_________
func copySign *(x,y :Fx) :Fx=
  ## Returns the value of x with the sign of y.
  result = abs(x)
  if y < Zero: result = -result

#___________________
# Arithmetic
func `*` *(f1,f2 :Fx) :Fx=
  ## Fixed point multiplication.
  ## Doesn't have [over,under]flow checks, but converts to BiggestInt on karatsuba mult.
  ## This will will increase the range covered by the number, unless Fx is set to use int64 specifically.
  ## Convert down to base, multiply, div by resolution so decimals are readjusted, and convert back to Fx
  (karatsuba(f1.FxBase, f2.FxBase) div FxResolution).Fx

func `*=`  *(f1 :var Fx; f2 :Fx) :void=  f1 = f1*f2
  ## Multiply f1 by f2 and apply to f1 in-place. Uses Fx*Fx operator

func `div` *(f1,f2 :Fx) :Fx= 
  ## Fixed point division.
  ## Convert down to base, divide, multiply by resolution so decimals are readjusted, and convert back to Fx
  ## NOTE:
  ## Dividing 0/0 is undefined behavior in mathematics, because both 0/0 == 1 and 0/0 == 0 are valid.
  ## Since dividing two 0s would mean dividing two unititialized values,
  ## it only makes sense (out of the two options) to return another unititialized value back to its caller.
  ## So, to avoid unnecesary crashes: 
  ## - Returns    0 when 0/0  (float would be nan)
  ## - Returns High when n/0  (float would be inf)
  if   f1 == Zero and f2 == Zero: return Zero  #     0/0 = undefined. Return unititialized value.
  elif f2 == Zero: return High.copySign(f1)    # (+-)n/0 = (+-)infinity. Saturate, instead of crash.
  ((f1.FxBase div f2.FxBase) * FxResolution).Fx

func `==`  *(f1 :Fx; n :SomeNumber) :bool=  f1 == n.fx
  ## Numbers are equal when n converted to Fx is eq to f1

#___________________
# Aliases
template `/`  *(f1,f2 :Fx) :Fx=    f1 div f2       ## Alias to div for ergonomics. Division will always use div
template `!=` *(f1,f2 :Fx) :bool=  not (f1 == f2)  ## Alias to `not f1 == f2`
template `==` *(n :SomeNumber; f1 :Fx) :bool=  n == f1  ## Alias to f1 == n. Numbers are equal when n converted to Fx is eq to f1
#___________________
# Extra Arithmetic
template `/` *(f1 :Fx; n :SomeNumber) :Fx=  f1 div n.fx  ## Division of an Fx type with SomeNumber, which converts SomeNumber to fx when necessary
template `/` *(n :SomeNumber; f1 :Fx) :Fx=  n.fx div f1  ## Division of SomeNumber with an Fx type, which converts SomeNumber to fx when necessary
template `*` *(f1 :Fx; n :SomeNumber) :Fx=  f1 * n.fx    ## Multiplication of an Fx type with SomeNumber, which converts SomeNumber to fx when necessary
template `*` *(n :SomeNumber; f1 :Fx) :Fx=  n.fx * f1    ## Multiplication of SomeNumber with an Fx type, which converts SomeNumber to fx when necessary

#___________________
# Square roots
proc linearAscend    *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearAscend.Fx
proc linearAscendAdd *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearAscendAdd.Fx
proc linearDescend   *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearDescend.Fx
proc binarySearch    *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).binarySearch.Fx
proc binaryTwo       *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).binaryTwo.Fx
proc sqrt            *(f1 :Fx) :Fx=  f1.binaryTwo

#___________________
# Powers
proc pow *(f1 :Fx; n :Natural) :Fx=
  ## Calculates f1 raised to the power of n.
  if n == 0: return 1.fx
  result = f1
  for it in 1..<n:
    result *= f1
template sqr  *(f1 :Fx) :Fx=  f1*f1  ## Calculates f1 squared
template pow2 *(f1 :Fx) :Fx=  f1*f1  ## Calculates f1 squared
template `^`  *(f1 :Fx; n :Natural) :Fx=  f1.pow(n)  ## Alias for f1.pow(n)


#_________________________
# Conversion
#___________________
proc toBase  *(fx :Fx) :FxBase=     fx.FxBase                  ## Converts the fixed point number to its raw FxBase type representation
proc toFloat *(fx :Fx) :SomeFloat=  FxBase(fx) / FxResolution  ## Converts the fixed point number to float32 or float64

#_________________________
# String conversion
#___________________
proc `$` *(fx :Fx) :string=  fx.toFloat.formatFloat(ffDecimal, FxPrecision)

