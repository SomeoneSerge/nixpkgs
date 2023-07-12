{ lib
, baseStdenv
, buildPackages
, hostLibstdcxxForStdenv
, ccForStdenv
, stdenvAdapters
, targetPlatform
, wrapCCWith
}:

let
  cc = (buildPackages.wrapCCWith { cc = ccForStdenv; }).overrideAttrs (oldAttrs: {
    postFixup = (oldAttrs.postFixup or "") + ''

      # When we're taking libstdc++ from a native toolchain
      echo " -L${hostLibstdcxxForStdenv}/lib" >> $out/nix-support/cc-ldflags

      # Taking target libstdc++ from a cross toolchain
      if [[ -d ${hostLibstdcxxForStdenv}/${targetPlatform.config}/lib ]] ; then
        echo " -L${hostLibstdcxxForStdenv}/${targetPlatform.config}/lib" >> $out/nix-support/cc-ldflags
      fi
    '';
  });
  cudaStdenv = stdenvAdapters.overrideCC baseStdenv cc;
  passthruExtra = {
    inherit hostLibstdcxxForStdenv;
    # cc already exposed
  };
  assertCondition = true;
in
lib.extendDerivation
  assertCondition
  passthruExtra
  cudaStdenv

