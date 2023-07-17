{ lib
, buildPackages
, gccForLibs
, ccForStdenv
, backendStdenvBase
, stdenvAdapters
, targetPlatform
, wrapCCWith
}:

let
  cc = (buildPackages.wrapCCWith {
    cc = ccForStdenv;
    gccForLibs = gccForLibs;
    libcxx = gccForLibs.lib;
  });
  cudaStdenv = stdenvAdapters.overrideCC backendStdenvBase cc;
  passthruExtra = { };
  assertCondition = true;
in
lib.extendDerivation
  assertCondition
  passthruExtra
  cudaStdenv

