module OMParser

using MetaModelica

import MKAbsyn, ImmutableList
#= For searching files.. =#
import Glob

#import Settings
const INSTALLATION_DIRECTORY_PATH = realpath(realpath(dirname(Base.find_package("OMParser")) * "/../"))

#Shared path
const SHARED_DIRECTORY_PATH = realpath(string(INSTALLATION_DIRECTORY_PATH, "/lib/ext"))

struct ParseError
end

function isDerCref(exp::MKAbsyn.Exp)::Bool
  @match exp begin
    MKAbsyn.CALL(MKAbsyn.CREF_IDENT("der",  nil()), MKAbsyn.FUNCTIONARGS(MKAbsyn.CREF(__) <|  nil(),  nil()), nil())  => true
    _ => false
  end
end

"""
  This function finds libraries built by the user or by the CI
"""
function _locateSharedParserLibrary(directoryToSearchIn)
  local res = Glob.glob("*",  joinpath(directoryToSearchIn, "lib"))
  local results = []
  for p in res
    push!(results, Glob.glob("*",  joinpath(directoryToSearchIn, p)))
  end
  #= Locate DLL =#
  if Sys.islinux()
    for r in results
      for p in r
        if occursin("libomparse-julia.so", p)
          return p
        end
      end
    end
  elseif Sys.iswindows()
    for r in results
      for p in r
        if occursin("libomparse-julia.dll", p)
          return p
        end
      end
    end
  else #= Assume apple=#
    for r in results
      for p in r
        if occursin("libomparse-julia.dylib", p)
          return p
        end
      end
    end
  end
end

"""
  This function finds precompiled paths
"""
function locateSharedParserLibrary(directoryToSearchIn)
  local res = Glob.glob("*",  joinpath(directoryToSearchIn, "shared"))
  local results = []
  println()
  for p in res
    push!(results, Glob.glob("*",  joinpath(directoryToSearchIn, p)))
  end
  #= Locate DLL =#
  if Sys.islinux()
    for r in results
      for p in r
        if occursin("libomparse-julia.so", p)
          return p
        end
      end
    end
  elseif Sys.iswindows()
    for r in results
      for p in r
        if occursin("libomparse-julia.dll", p)
          return p
        end
      end
    end
  else #= Assume apple=#
    for r in results
      for p in r
        if occursin("libomparse-julia.dylib", p)
          return p
        end
      end
    end
  end
end

const _libpath = if Sys.iswindows()
  _locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
elseif Sys.islinux()
  _locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
elseif Sys.isapple()
  _locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
else
  throw("Your system is not supported. Supported Systems are Linux, macOS and Windows.")
end

#= Lib path for externally downloaded parser libraries =#
const libpath = if Sys.iswindows()
  locateSharedParserLibrary(SHARED_DIRECTORY_PATH)
elseif Sys.islinux()
  locateSharedParserLibrary(SHARED_DIRECTORY_PATH)
elseif Sys.isapple()
  locateSharedParserLibrary(SHARED_DIRECTORY_PATH)
else
  throw("Your system is not supported. Supported Systems are Linux, macOS and Windows.")
end


#= If there exists a prebuilt library we use that. Otherwise we use the precompiled binary generated by Pkg.build =#
const installedLibPath = if _libpath != nothing
    _libpath
  else
    libpath
end

# langStd:
# ("1.x", 10), ("2.x", 20), ("3.0", 30), ("3.1", 31), ("3.2", 32), ("3.3", 33),
# ("3.4", 34), ("3.5", 35), ("latest",1000), ("experimental", 9999)
# acceptedGram:
# 1=Modelica, 2=MetaModelica, 3=ParModelica, 4=Optimica, 5=PdeModelica
function parseString(contents::String,
                     interactiveFileName::String = "<default>",
                     acceptedGram::Int64 = 1,
                     languageStandard::Int64 = 1000)::MKAbsyn.Program
  local res = ccall((:parseString, installedLibPath), Any, (String, String, Int64, Int64), contents, interactiveFileName, acceptedGram, languageStandard)
  if res == nothing
    throw(ParseError())
  end
  res
end

# langStd:
# ("1.x", 10), ("2.x", 20), ("3.0", 30), ("3.1", 31), ("3.2", 32), ("3.3", 33),
# ("3.4", 34), ("3.5", 35), ("latest",1000), ("experimental", 9999)
# acceptedGram:
# 1=Modelica, 2=MetaModelica, 3=ParModelica, 4=Optimica, 5=PdeModelica
function parseFile(fileName::String, acceptedGram::Int64 = 1, languageStandard::Int64 = 9999)::MKAbsyn.Program
  local res = ccall((:parseFile, installedLibPath), Any, (String, Int64, Int64), fileName, acceptedGram, languageStandard)
  if res == nothing
    throw(ParseError())
  end
  res
end

end