#:_____________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher :
#:_____________________________________________________________
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
# Basic Arithmetic
#___________________
# Internal   TODO: Are they needed ?
func `-`  (f1 :Fx; n :FxBase) :FxBase=  f1.FxBase - n
func `-`  (n :FxBase; f1 :Fx) :FxBase=  FxBase(n - f1.FxBase)
#___________________
# Temp Fix
# func `-` *(f1,f2 :Fx) :Fx=  (f1.FxBase - f2.FxBase).Fx
#___________________
# External
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
# Specific. Cannot borrow
func `*`  *(f1,f2 :Fx) :Fx=  ((f1.FxBase*f2.FxBase) div FxResolution).Fx
func `*=` *(f1 :var Fx; f2 :Fx) :void=  f1 = f1*f2
  ## Fixed point multiplication. Cast down to base, multiply, div by resolution so decimals are readjusted, and cast to Fx
func `div` *(f1,f2 :Fx) :Fx= ((f1.FxBase div f2.FxBase) * FxResolution).Fx
  ## Fixed point division. Cast down to base, divide, multiply by resolution so decimals are readjusted, and cast to Fx

# Aliases
template `/`  *(f1,f2 :Fx) :Fx=    f1 div f2     ## Alias to div for ergonomics. Division will always use div
template `!=` *(f1,f2 :Fx) :bool=  not f1 == f2  ## Alias to `not a == b`
# Extra Arithmetic
template `/` *(f1 :Fx; n :SomeNumber) :Fx=  f1 div n.fx  ## Division of an Fx type with SomeNumber, which converts SomeNumber to fx when necessary
template `/` *(n :SomeNumber; f1 :Fx) :Fx=  n.fx div f1  ## Division of SomeNumber with an Fx type, which converts SomeNumber to fx when necessary
template `*` *(f1 :Fx; n :SomeNumber) :Fx=  f1 * n.fx    ## Multiplication of an Fx type with SomeNumber, which converts SomeNumber to fx when necessary
template `*` *(n :SomeNumber; f1 :Fx) :Fx=  n.fx * f1    ## Multiplication of SomeNumber with an Fx type, which converts SomeNumber to fx when necessary
proc sign *(v :Fx) :Fx=  # modified from vmath to fit the type correctly
  ## Returns the sign of the Fx number, -1 or 1.
  if v >= 0.fx: 1.fx else: -1.fx

# Square roots
proc linearAscend    *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearAscend.Fx
proc linearAscendAdd *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearAscendAdd.Fx
proc linearDescend   *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).linearDescend.Fx
proc binarySearch    *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).binarySearch.Fx
proc binaryTwo       *(f1 :Fx) :Fx=  (f1.FxBase * FxResolution).binaryTwo.Fx
proc sqrt            *(f1 :Fx) :Fx=  f1.binaryTwo



#_________________________
# Conversion
#___________________
const WholeMax * = FxBase.high.whole                         ## Filter for getting the whole part.
const FracMax  * = FxBase.high.frac                          ## Filter for getting the fractional part.
proc toBase  *(fx :Fx) :FxBase=     fx.FxBase                ## Converts the fixed point number to its raw FxBase type representation
proc toFloat *(fx :Fx) :SomeFloat=  FxBase(fx) / FxResolution  ## Converts the fixed point number to float32 or float64

#_________________________
# String conversion
#___________________
proc `$` *(fx :Fx) :string=  fx.toFloat.formatFloat(ffDecimal, 4)
