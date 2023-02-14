#:_______________________________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT                   :
#  This file contains modified code from MikeLankamp/fpm (MIT)   :
#  Check the doc/licenses folder for more info about its license :
#:_______________________________________________________________
# std dependencies
from std/math as sm import nil
# Module dependencies
import ./fx


#_____________________________
# Constants
#___________________
const Tau    *:Fx= sm.TAU.fx
const Pi     *:Fx= sm.PI.fx
const PiHalf *:Fx= Pi / 2


#_____________________________
# Functions
#___________________
func sin *(f1 :Fx) :Fx=
  ## Fifth-order Taylor polynomial.
  ## Curve-fitting approximation algorithm originally described by Jasper Vijn on coranac.com
  ## It has a worst-case relative error of 0.07% (over [-pi:pi]).
  ## Explanations of Taylor theorem:
  ## - Simple    by Khan Academy:  https://www.youtube.com/watch?v=8SsC5st4LnI
  ## - Advanced  by  3Blue1Brown:  https://www.youtube.com/watch?v=3d6DsjIBzJ4
  ## - Math of Taylor polynomial for sin(x):  https://www.youtube.com/watch?v=bxi1xMBhCM0
  # Turn x from [0..2*PI] domain into [0..4] domain
  var x :Fx= f1 mod Tau
  x = x / PiHalf
  # Take x modulo one rotation, so [-4..+4].
  if x < Zero:
    x += 4.fx
  # Init the sign as positive
  var sign :Fx= One
  # Restrict domain to [0..2].
  if x > Two:
    sign = -One
    x -= Two
  # Restrict domain to [0..1].
  if x > One:
    x = Two - x
  # Calculate the polynomial
  let x2 :Fx= x*x  # Compute x squared only once
  result = sign * x * (Pi - x2 * (Tau - 5.fx - x2 * (Pi - 3.fx)) )/Two

#___________________
func cos *(f1 :Fx) :Fx=  sin(PiHalf + f1)
  ## Calculates the cos of the given Fx number, by doing sin(Pi/2 + number)

#___________________
func tan *(f1 :Fx) :Fx=
  ## Calculates the tan of the given Fx number, by doing sin(number)/cos(number)
  ## Raises an exception when the tangent goes to infinity (90 and -90deg)
  let cx :Fx= cos(f1)
  # Tangent goes to infinity at 90 and -90 degrees.
  # Fx type cannot represent infinity, so check that the cos result is within range.
  if cx > One: raise newException(FxError, "Can't compute tangent of the number. Its cos goes to infinity.")
  result = sin(f1) / cx

#___________________
func atanNorm *(x :Fx) :Fx=
  ## Calculates atan(x) assuming that x is in the range [0,1]
  if not (x >= Zero and x <= One): raise newException(FxError, "Value for atanNorm needs to be normalized [0..1]")
  const fA :Fx=  0.0776509570923569.fx  # Was from_fixed_point<63>(  716203666280654660ll
  const fB :Fx= -0.2874344753930280.fx  # Was from_fixed_point<63>(-2651115102768076601ll
  const fC :Fx=  0.9951816816981190.fx  # Was from_fixed_point<63>( 9178930894564541004ll
  let x2 :Fx= x*x
  result = ((fA*x2 + fB)*x2 + fC) * x

#___________________
func atanDiv *(y,x :Fx) :Fx=
  ## Calculates atan(y / x), assuming x != 0.
  # If x is very, very small, y/x can easily overflow the fixed-point range.
  # If q = y/x and q > 1, atan(q) would calculate atan(1/q) as an intermediate step anyway.
  # We can shortcut that and avoid the loss of information, thus improving the accuracy of atan(y/x) for very small x.
  assert x != Zero
  # Make sure y and x are positive.
  # If y / x is negative (when y or x, but not both, are negative), negate the result to keep the correct outcome.
  if y < Zero:
    if x < Zero: return  atanDiv(-y, -x)
    else:        return -atanDiv(-y,  x)
  if x < Zero:   return -atanDiv( y, -x)
  assert y >= Zero and x > Zero
  if y > x: result = PiHalf - atanNorm(x/y)
  else:     result = atanNorm(y/x)

#___________________
func atan2 *(y, x :Fx) :Fx=
  if x == Zero:
    assert y != Zero
    if y > Zero: return  PiHalf
    else:        return -PiHalf
  result = atanDiv(y, x)
  if x < Zero:
    if y >= Zero: result += Pi
    else:         result -= Pi

#___________________
func atan *(x :Fx) :Fx=
  if x < Zero: return -atan(-x)
  if x > One:  return PiHalf - atanNorm(One/x)
  result = atanNorm(x)

#___________________
func asin *(x :Fx) :Fx=
  assert x >= -One and x <= One
  let yy :Fx= One - x*x
  if yy == Zero: result = copySign(PiHalf, x)
  else:          result = atanDiv(x, sqrt(yy))

#___________________
func acos *(x :Fx) :Fx=
  assert x >= -One and x <= One
  if x == -One: return Pi
  let yy :Fx= One - x*x
  result = Two * atanDiv(sqrt(yy), One + x)

#___________________
# Aliases for std name compatibility
template arcsin  *(x :Fx) :Fx=  asin(x)
template arccos  *(x :Fx) :Fx=  acos(x)
template arctan  *(y, x :Fx) :Fx=   atan(y,x)
template arctan2 *(y, x :Fx) :Fx=  atan2(y,x)

