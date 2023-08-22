#:_______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# Test dependencies
import nfx
import ./helpers

#_______________________________________
test &"{nfxPrefix} Constructors: API":
  when FxBase is int32 and FxPrecision == 4:
    # Check known bits
    check fx(0) == cast[Fx](0b0000_0000_0000_0000_0000_0000_0000_0000'i32)
    check fx(1) == cast[Fx](0b0000_0000_0000_0000_0010_0111_0001_0000'i32)
    check fx(2) == cast[Fx](0b0000_0000_0000_0000_0100_1110_0010_0000'i32)
    check fx(4) == cast[Fx](0b0000_0000_0000_0000_1001_1100_0100_0000'i32)
    check fx(5) == cast[Fx](0b0000_0000_0000_0000_1100_0011_0101_0000'i32)
    check fx(6) == cast[Fx](0b0000_0000_0000_0000_1110_1010_0110_0000'i32)
    check fx(8) == cast[Fx](0b0000_0000_0000_0001_0011_1000_1000_0000'i32)
    check fx(float32.high) == cast[Fx](FxBase.low)
    check fx( 2.0) == fx(2)
    check fx(0.9999).toFloat == 0.9999
    # check fx(42.0)
  else: {.warning: &"There are no Constructors:API tests designed for the case when FxBase is a {FxBase.basetype} with {FxPrecision} decimals of precision.".}




#_______________________________________
test &"{nfxPrefix} Getters":
  # Default constructors
  discard





