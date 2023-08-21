#:______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:______________________________________________
# std dependencies
import std/math
import std/strutils
# External dependencies
import pkg/print
# Project dependencies
import nfx

let input :float64= 420185185

let expect = input.sqrt.fx.toFloat
print ".................."
print input, expect

# Base numbers
let wholeI    = 1
let wholeF    = 1.0000
let frac      = 0.2000
let both      = 3.4500
let bothLong  = 3.4567890123456789
# Converted numbers
let wholeFxF  = wholeF.fx
let wholeFxI  = wholeI.fx
let fracFx    = frac.fx
let bothFx    = both.fx
proc conversion()=
  assert   wholeI.fx.toFloat == wholeI.toFloat
  assert   wholeF.fx.toFloat == wholeF
  assert bothLong.fx.toFloat == bothLong

# Addition
proc addition()=
  echo $(wholeFxF + fracFx)   ; assert (wholeFxF +   fracFx).toFloat == 1.0+0.2
  echo $(wholeFxF + bothFx)   ; assert (wholeFxF +   bothFx).toFloat == 1.0+3.45
  echo $(fracFx   + bothFx)   ; assert (fracFx   +   bothFx).toFloat == 3.65
  echo $(fracFx   + wholeFxF) ; assert (fracFx   + wholeFxF).toFloat == 0.2+1.0
  echo $(bothFx   + wholeFxF) ; assert (bothFx   + wholeFxF).toFloat == 3.45+1.0
  echo $(bothFx   + fracFx)
  #      whole op frac
  #      whole op both
  #      frac  op both
  #      frac  op whole
  #      both  op whole
  #      both  op frac
template toStr(f :SomeFloat) :string= f.formatFloat(ffDecimal, 4)
template genTest(op :untyped; msg :string)=
  echo "________________________________________"
  echo "Test : ",msg
  echo "1: ",wholeFxF," ",fracFx," | ",op(wholeFxF, fracFx)  ; assert op(wholeFxF,  fracFx).toFloat.toStr == op(wholeF, frac).toStr
  echo "2: ",wholeFxF," ",bothFx," | ",op(wholeFxF, bothFx)  ; assert op(wholeFxF,  bothFx).toFloat.toStr == op(wholeF, both).toStr
  echo "3: ",wholeFxI," ",fracFx," | ",op(wholeFxI, fracFx)  ; assert op(wholeFxI,  fracFx).toFloat.toStr == op(wholeI.float, frac).toStr
  echo "4: ",wholeFxI," ",bothFx," | ",op(wholeFxI, bothFx)  ; assert op(wholeFxI,  bothFx).toFloat.toStr == op(wholeI.float, both).toStr
  echo "_________________"
  echo "5: ",fracFx," ",bothFx,  " | ",op(fracFx,  bothFx)   ; assert op(fracFx,    bothFx).toFloat.toStr == op(frac,   both).toStr
  echo "6: ",fracFx," ",wholeFxF," | ",op(fracFx,  wholeFxF) ; assert op(fracFx,  wholeFxF).toFloat.toStr == op(frac,   wholeF).toStr
  echo "7: ",fracFx," ",wholeFxI," | ",op(fracFx,  wholeFxI) ; assert op(fracFx,  wholeFxI).toFloat.toStr == op(frac,   wholeI.float).toStr
  echo "_________________"
  echo "8: ",bothFx," ",wholeFxF," | ",op(bothFx,  wholeFxF) ; assert op(bothFx,  wholeFxF).toFloat.toStr == op(both,   wholeF).toStr
  echo "9: ",bothFx," ",wholeFxI," | ",op(bothFx,  wholeFxI) ; assert op(bothFx,  wholeFxI).toFloat.toStr == op(both,   wholeI.float).toStr
  echo "0: ",bothFx," ",fracFx,  " | ",op(bothFx,  fracFx)   ; assert op(bothFx,    fracFx).toFloat.toStr == op(both,   frac).toStr

import nfx/op/sqr

when isMainModule:
  genTest(`+`, "Addition")
  genTest(`-`, "Substraction")
  genTest(`*`, "Multiplication")
  genTest(`/`, "Division")
  genTest(`sqrt`, "SquareRoot")
