#:______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:______________________________________________

#___________________
# Package
packageName   = "nfx"
version       = "0.0.0"
author        = "sOkam"
description   = "Deterministic fixed point math for Nim"
license       = "MIT"

#___________________
# Build requirements
requires     "nim >= 1.6.10"    ## Current stable
# taskRequires "test", "print"

#___________________
# Folders
srcDir           = "src"
binDir           = "bin"
let testsDir     = "tests"
let examplesDir  = "examples"
let docDir       = "doc"
skipdirs         = @[binDir, examplesDir, testsDir, docDir]

#________________________________________
# Helpers
#___________________
import std/strformat
import std/os
#___________________
let nimcr = &"nim c -r --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir :string) :void=  exec &"{nimcr} {dir/file}"
  ## Runs file from the given dir, using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder


#________________________________________
# Tasks: Documentation
# task docs, "Build documentation":  exec "nim doc --index:on --outdir:pages --project src/fpn.nim"
#___________________
# Tasks: Examples
# task example_simple,  "Compiles and runs the simple example.":   "simple01.nim".runExample
#___________________
# Tasks: Tests
# task test_init,              "init tests":               "init.nim".runTest
# task test_addition,          "addition tests":           "addition.nim".runTest
# task test_substraction,      "substraction tests":       "substraction.nim".runTest
# task test_multiplication,    "multiplication tests":     "multiplication.nim".runTest
# task test_division,          "division tests":           "division.nim".runTest
# task test_abs,               "abs tests":                "abs.nim".runTest
# task test_ceil,              "ceil tests":               "ceil.nim".runTest
# task test_floor,             "floor tests":              "floor.nim".runtest
# task test_round,             "round tests":              "round.nim".runtest
# task test_whole_float_parts, "whole/float parts tests":  "whole_float_parts.nim".runtest
# task test_square_root,       "square root tests":        "square_root.nim".runtest
# task test_pi_e,              "pi and e tests":           "pi_e.nim".runtest
# task test_log,               "ilog tests":               "log.nim".runtest
# task test_string,            "fromString and $ tests":   "string.nim".runtest
# #___________________
# task test, "Runs all tests":
#   exec "nimble test_init"
#   exec "nimble test_addition"
#   exec "nimble test_substraction"
#   exec "nimble test_multiplication"
#   exec "nimble test_division"
#   exec "nimble test_abs"
#   exec "nimble test_ceil"
#   exec "nimble test_floor"
#   exec "nimble test_round"
#   exec "nimble test_whole_float_parts"
#   exec "nimble test_square_root"
#   exec "nimble test_pi_e"
#   exec "nimble test_log"
#   exec "nimble test_string"
