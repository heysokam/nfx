#:___________________________________________________
#  nfx  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________

#_______________________________________
# Exposed Configuration switches
const nfxPrefix    *{.strdefine.}= "「nfx」"
  ## Prefix used by the library when reporting messages back to the user
const nfxBaseType  *{.intdefine.}=  0
  ## default:0 means int32 -> Underlying size of the Type used to hold fixed point numbers
const nfxPrecision *{.intdefine.}=  4
  ## Default precision. Configurable with the -d:nfxPrecision:N compile-time switch

