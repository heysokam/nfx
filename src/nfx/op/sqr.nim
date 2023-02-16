#:______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:______________________________________________


#_______________________________________
proc linearAscend *(n :SomeInteger) :SomeInteger=
  ## Integer square root (linear search, ascending)
  # Initial underestimate, S <= isqrt(trg)
  result = 0 # Start searching at 0
  let trg :typeof(n)= n
  while ((result+1)*(result+1) <= trg):
    result.inc

#_______________________________________
proc linearDescend *(n :SomeInteger) :SomeInteger=
  ## Integer square root (linear search, descending)
  # Initial overestimate, isqrt(y) <= S
  result = n  # Start searching at n
  let trg :typeof(n)= n
  while result*result > trg:
    result.dec

#_______________________________________
proc linearAscendAdd *(n :SomeInteger) :SomeInteger=
  ## Integer square root (linear search, ascending, using addition)
  result = 0 # Start searching at 0
  let trg :typeof(n)= n
  var a   :typeof(n)= 1
  var d   :typeof(n)= 3
  while a <= trg:
    a = a + d # (a+1) ^ 2
    d = d + 2
    result.inc

#_______________________________________
proc binarySearch *(n :SomeInteger) :SomeInteger=
  ## Integer square root (binary search)
  let trg   :typeof(n)= n
  var left  :typeof(n)= 0
  var mid   :typeof(n)
  var right :typeof(n)= trg + 1
  while left != right-1:
    mid = (left+right) div 2
    if mid*mid <= trg: left  = mid
    else:              right = mid
  result = left

#_______________________________________
proc binaryTwo *(n :SomeInteger) :SomeInteger=
  ## Integer square root, using the digit-by-digit base2 method.
  ## https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Example_3
  assert n >= 0, "sqrt input should be non-negative"
  # result = 0           #  cₙ
  var num :typeof(n)= n  #  Xₙ₊₁
  #  bitₙ which starts at the highest power of four <= n
  var bit :typeof(n)= 1 shl (sizeof(n)*8 - 2)  # Set the second-to-top bit as active. Same as ((unsigned) INT32_MAX + 1) / 2.

  while (bit > num):
    bit = bit shr 2
    while (bit != 0):                  #  for dₙ … d₀
      if (num >= result + bit):        #  if Xₘ₊₁ ≥ Yₘ then aₘ = 2ᵐ
        num   -= result + bit          #  Xₘ = Xₘ₊₁ - Yₘ
        result = (result shr 1) + bit  #  cₘ₋₁ = cₘ/2 + dₘ (aₘ is 2ᵐ)
      else:
        result = result shr 1          #  cₘ₋₁ = cₘ/2      (aₘ is 0)
      bit = bit shr 2                  #  dₘ₋₁ = dₘ/4
  # result will be:    c₋₁


#_______________________________________
proc isqrt *(n :SomeInteger) :SomeInteger=  n.binaryTwo
  ## Computes the integer square root of the number,
  ## using the method that has been found to be the fastest.
  ## See the sqr.nim file for alternative methods.
  ## Current: digit-by-digit in base2  ->  binaryTwo(n)

