# Type Aliases
#
# See ./extension.nix:
# - ReleaseAttrs
# - ReleaseFeaturesAttrs
#
# General callPackage-supplied arguments
{ lib
, stdenv
, backendStdenv
, fetchurl
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, cudaFlags
, markForCudatoolkitRootHook
, lndir
, symlinkJoin
}:
# Function arguments
{
  # Short package name (e.g., "cuda_cccl")
  # pname : String
  pname
, # Long package name (e.g., "CXX Core Compute Libraries")
  # description : String
  description
, # version : Version
  version
, # packageAttrs : PackageAttrs
  packageAttrs
, # packageFeatureAttrs : PackageFeatureAttrs
  packageFeatureAttrs
,
}:
let
  # Useful imports
  inherit (builtins) attrNames head filter;
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.meta) getExe;
  inherit (lib.strings) optionalString;

  # TODO: Take those from the manifest instead
  # TODO: Provide a way to ignore the gencodes and choose the release manually
  gencodesDiscrete = [
    "3.0"
    "3.5"
    "3.7"
    "5.0"
    "5.2"
    "6.0"
    "6.1"
    "7.0"
    "7.5"
    "8.0"
    "8.6"
    "8.9"
    "9.0"
  ];
  gencodesJetson = [
    "3.2"
    "5.3"
    "6.2"
    "7.2"
    "8.7"
  ];
  hostOnlyPnames = [
    "cuda_nvcc"
    "cuda_cudart"
  ];
  platformMap = {
    linux-x86_64.system = "x86_64-linux";
    linux-x86_64.gencodes = gencodesDiscrete;

    linux-sbsa.system = "aarch64-linux";
    linux-sbsa.gencodes = gencodesDiscrete;

    linux-aarch64.system = "aarch64-linux";
    linux-aarch64.gencodes = gencodesJetson;

    linux-ppc64le.system = "powerpc64le-linux";
    linux-ppc64le.gencodes = gencodesDiscrete;

    windows-x86_64.system = "x86_64-windows";
    windows-x86_64.gencodes = gencodesDiscrete;
  };
  platforms = builtins.map
    (releaseName: platformMap.${releaseName}.system)
    (attrNames packageFeatureAttrs);

  releaseNames = attrNames packageFeatureAttrs;
  supportsHost = releaseName: (platformMap.${releaseName}.system or null) == stdenv.hostPlatform.system;
  suppliesGencodes = releaseName:
    builtins.all
      (sm:
        let gencodes = platformMap.${releaseName}.gencodes or [ ];
        in gencodes == [ ] || builtins.elem pname hostOnlyPnames || builtins.elem sm gencodes)
      cudaFlags.cudaCapabilities;
  supportedReleases = filter (release: builtins.all (test: test release) [ supportsHost suppliesGencodes ]) releaseNames;
  isSupported = supportedReleases != [ ];
  release = head supportedReleases;

in
backendStdenv.mkDerivation (optionalAttrs isSupported {
  # NOTE: Even though there's no actual buildPhase going on here, the derivations of the
  # redistributables are sensitive to the compiler flags provided to stdenv. The patchelf package
  # is sensitive to the compiler flags provided to stdenv, and we depend on it. As such, we are
  # also sensitive to the compiler flags provided to stdenv.
  inherit pname version;
  strictDeps = true;

  outputs = with packageFeatureAttrs.${release};
    [ "out" ]
    ++ optionals hasBin [ "bin" ]
    ++ optionals hasLib [ "lib" ]
    ++ optionals hasStatic [ "static" ]
    ++ optionals hasDev [ "dev" ]
    ++ optionals hasDoc [ "doc" ]
    ++ optionals hasSample [ "sample" ];

  src = fetchurl {
    url = "https://developer.download.nvidia.com/compute/cuda/redist/${packageAttrs.${release}.relative_path}";
    inherit (packageAttrs.${release}) sha256;
  };

  # We do need some other phases, like configurePhase, so the multiple-output setup hook works.
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    # This hook will make sure libcuda can be found
    # in typically /lib/opengl-driver by adding that
    # directory to the rpath of all ELF binaries.
    # Check e.g. with `patchelf --print-rpath path/to/my/binary
    autoAddOpenGLRunpathHook
    markForCudatoolkitRootHook
  ];

  buildInputs = [
    # autoPatchelfHook will search for a libstdc++ and we're giving it
    # one that is compatible with the rest of nixpkgs, even when
    # nvcc forces us to use an older gcc
    # NB: We don't actually know if this is the right thing to do
    stdenv.cc.cc.lib
  ];

  # Picked up by autoPatchelf
  # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
  appendRunpaths = [
    "$ORIGIN"
  ];

  installPhase = with packageFeatureAttrs.${release};
    # Pre-install hook
    ''
      runHook preInstall
    ''
    # doc and dev have special output handling. Other outputs need to be moved to their own
    # output.
    # Note that moveToOutput operates on all outputs:
    # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L105-L107
    + ''
      mkdir -p "$out"
      rm LICENSE
      mv * "$out"
    ''
    # Handle bin, which defaults to out
    + optionalString hasBin ''
      moveToOutput "bin" "$bin"
    ''
    # Handle lib, which defaults to out
    + optionalString hasLib ''
      moveToOutput "lib" "$lib"
    ''
    # Handle static libs, which isn't handled by the setup hook
    + optionalString hasStatic ''
      moveToOutput "**/*.a" "$static"
    ''
    # Handle samples, which isn't handled by the setup hook
    + optionalString hasSample ''
      moveToOutput "samples" "$sample"
    ''
    # Post-install hook
    + ''
      runHook postInstall
    '';

  # The out output leverages the same functionality which backs the `symlinkJoin` function in
  # Nixpkgs:
  # https://github.com/NixOS/nixpkgs/blob/d8b2a92df48f9b08d68b0132ce7adfbdbc1fbfac/pkgs/build-support/trivial-builders/default.nix#L510
  #
  # That should allow us to emulate "fat" default outputs without having to actually create them.
  #
  # It is important that this run after the autoPatchelfHook, otherwise the symlinks in out will reference libraries in lib, creating a circular dependency.
  postPhases = [ "postPatchelf" ];
  # For each output, create a symlink to it in the out output.
  # NOTE: We must recreate the out output here, because the setup hook will have deleted it
  # if it was empty.
  # NOTE: Do not use optionalString based on whether `outputs` contains only `out` -- phases
  # which are empty strings are skipped/unset and result in errors of the form "command not
  # found: <customPhaseName>".
  postPatchelf = ''
    mkdir -p "$out"
    for output in $outputs; do
      if [ "$output" = "out" ]; then
        continue
      fi
      ${getExe lndir} "''${!output}" "$out"
    done
  '';

  # Setting propagatedBuildInputs to false will prevent outputs known to the multiple-outputs
  # from depending on `out` by default.
  # https://github.com/NixOS/nixpkgs/blob/2920b6fc16a9ed5d51429e94238b28306ceda79e/pkgs/build-support/setup-hooks/multiple-outputs.sh#L196
  # Indeed, we want to do the opposite -- fat "out" outputs that contain all the other outputs.
  propagatedBuildOutputs = false;

  # By default, if the dev output exists it just uses that.
  # However, because we disabled propagatedBuildOutputs, dev doesn't contain libraries or
  # anything of the sort. To remedy this, we set outputSpecified to true, and use
  # outputsToInstall, which tells Nix which outputs to use when the package name is used
  # unqualified (that is, without an explicit output).
  outputSpecified = true;

} //  {
  # Make the CUDA-patched stdenv available
  passthru.stdenv = backendStdenv;
  passthru.supportedReleases = supportedReleases;
  meta = {
    inherit description platforms;
    broken = !isSupported;
    license = lib.licenses.unfree;
    maintainers = lib.teams.cuda.members;
    # Force the use of the default, fat output by default (even though `dev` exists, which
    # causes Nix to prefer that output over the others if outputSpecified isn't set).
    outputsToInstall = [ "out" ];
  };
})
