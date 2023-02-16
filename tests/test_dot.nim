import pkg/vmath
import pkg/print
import nfx
import nfx/op

proc mul *(f1,f2 :Fx) :Fx=
  print karatsuba(f1.FxBase, f2.FxBase) div FxResolution
  if not isSafeMul(f1.FxBase, f2.FxBase):
    print f1, f2, FxBase.high
  (karatsuba(f1.FxBase, f2.FxBase) div FxResolution).Fx

# proc dot *[T](a,b :GVec3[T]) :T=  a.x.mul(b.x) + a.y.mul(b.y) + a.z.mul(b.z)
proc dot *[T](a,b :GVec3[T]) :T=  a.x.`*`(b.x) + a.y.`*`(b.y) + a.z.`*`(b.z)
let f1 :Fx= 32.0.fx
let f2 :Fx= 64.0.fx
let fv1 :GVec3[Fx]= gvec3[Fx](f1, f1, f1)
let fv2 :GVec3[Fx]= gvec3[Fx](f2, f2, f2)

echo fv1.dot(fv2)

let v1 = vec3(32.0, 32.0, 32.0)
let v2 = vec3(64.0, 64.0, 64.0)
echo v1.dot(v2)
