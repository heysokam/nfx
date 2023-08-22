#:___________________________________________________
#  nfx  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import nfx
import ./helpers

#_______________________________________
test &"{nfxPrefix} Constructors: Default":
  check default(Fx) == default(FxBase)
  when FxBase is int32:
    check Fx(-80_000).int32 == (-80_000).FxBase.int32
  else: {.warning: &"There are no Constructors:Default tests designed for the case when FxBase is a {FxBase.basetype} with {FxPrecision} decimals of precision.".}

#_______________________________________
test &"{nfxPrefix} Constructors: Resolution":
  check fx(  1).FxBase == FxResolution
  check fx( 42).FxBase == FxResolution*42
  check fx(2.0).FxBase.float == FxResolution.float * 2.0

