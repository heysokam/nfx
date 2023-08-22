#:___________________________________________________
#  nfx  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# std dependencies for all tests
import std/unittest  ; export unittest
import std/strformat ; export strformat
import std/strutils  ; export strutils
# n*dk dependencies for all tests
import nstd ; export nstd
# tests dependencies
import nfx
import ./cfg

#_______________________________________
func getHex *[T](v:T) :string=
  ## Returns a string with the hex representation of the value formatted for easy comparison
  for id,ch in v.toHex().pairs:
    if id mod cfg.ByteLenHex == 0:
      result.add '_'
    result.add ch
  result = "0x" & result
#_______________________________________
func bitSize *[T](_:typedesc[T]) :Positive=  sizeof(T) * ByteLenBin
  ## Returns the size of a type in bits
func toBin *(v:BiggestUint; len:Positive) :string {.inline.}=  toBin(cast[BiggestInt](v), len)
  ## Returns a string with the bin representation of the given float. Missing in std/ for floats
func toBin *(v:SomeFloat; len:Positive) :string {.inline.}=  toBin(cast[BiggestUint](v), len)
  ## Returns a string with the bin representation of the given float. Missing in std/ for floats
func getBin *[T](v:T) :string=
  ## Returns a string with the bit representation of the value formatted for easy comparison
  for id,ch in v.toBin(T.bitSize).pairs:
    if id mod (cfg.ByteLenBin div 2) == 0:
      result.add '_'
    result.add ch
  result = "0b" & result
#_______________________________________
func compare *[T1,T2 :not object](v1:T1; v2:T2) :bool=  cast[BiggestUint](v1) == cast[BiggestUint](v2)
  ## Compares any numerical type to any other numerical type
  ## by casting both to their uint representation, and `==` the resulting values.

