#:______________________________________________
#  nfx : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:______________________________________________
import std/[ os,strformat ]

#___________________
# Package
packageName   = "nfx"
version       = "0.0.0"
author        = "sOkam"
description   = "n*fx | Deterministic fixed point math for Nim"
license       = "MIT"
let gitURL    = &"https://github.com/heysokam/{packageName}"

#___________________
# Build requirements
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/nmath"  ## Math tools and extensions

#___________________
# Folders
srcDir          = "src"
binDir          = "bin"
let docDir      = "doc"
let testsDir    = "tests"
let examplesDir = "examples"


#________________________________________
# Helpers
#___________________
const vlevel = when defined(debug): 2 else: 1
const mode   = when defined(debug): "-d:debug" elif defined(release): "-d:release" elif defined(danger): "-d:danger" else: ""
let nimcr = &"nim c -r --verbosity:{vlevel} {mode} --hint:Conf:off --hint:Link:off --hint:Exec:off --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir, args :string) :void=  exec &"{nimcr} {dir/file} {args}"
  ## Runs file from the given dir, using the nimcr command, and passing it the given args
proc runFile (file :string) :void=  file.runFile( "", "" )
  ## Runs file using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir, "")
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir, "")
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
template example (name :untyped; descr,file :static string)=
  ## Generates a task to build+run the given example
  let sname = astToStr(name)  # string name
  taskRequires sname, "SomePackage__123"  ## Doc
  task name, descr:
    runExample file


#_________________________________________________
# Tasks: Internal
#___________________
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec "graffiti ./{packageName}.nimble"
#___________________
task tests, "Internal:  Builds and runs all tests in the testsDir folder.":
  requires "pretty"
  for file in testsDir.listFiles():
    if file.lastPathPart.startsWith('t'):
      try: runFile file
      except: echo &" └─ Failed to run one of the tests from  {file}"
#___________________
task docgen, "Internal:  Generates documentation using Nim's docgen tools.":
  echo &"{packageName}: Starting docgen..."
  exec &"nim doc --project --index:on --git.url:{gitURL} --outdir:{docDir}/gen src/{packageName}.nim"
  echo &"{packageName}: Done with docgen."



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
