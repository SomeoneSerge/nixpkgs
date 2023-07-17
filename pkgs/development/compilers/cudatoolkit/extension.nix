final: prev: let
  ### Cuda Toolkit

  # Function to build the class cudatoolkit package
  buildCudaToolkitPackage = final.callPackage ./common.nix;

  # Version info for the classic cudatoolkit packages that contain everything that is in redist.
  cudatoolkitVersions = final.lib.importTOML ./versions.toml;

  finalVersion = cudatoolkitVersions.${final.cudaVersion};

  # Exposed as cudaPackages.backendStdenv and has the same interface as any
  # "stdenv", except accessing backendStdenv.cc.cc (the unwrapped compiler) is
  # "undefined behaviour".
  #
  # This controls what compiler nvcc uses as a backend,
  # and it has to provide an officially supported one (e.g. gcc11 for cuda11).
  # This also controls which standard c++ library is linked to the resulting applications.
  #
  # Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
  backendStdenv = final.callPackage ./stdenv.nix { };

  ### Add classic cudatoolkit package
  cudatoolkit =
    let
      attrs = builtins.removeAttrs finalVersion [ "gcc" ];
      attrs' = attrs // { inherit backendStdenv; };
    in
    buildCudaToolkitPackage attrs';

  cudaFlags = final.callPackage ./flags.nix { };

  # Internal hook, used by cudatoolkit and cuda redist packages
  # to accommodate automatic CUDAToolkit_ROOT construction
  markForCudatoolkitRootHook = (final.callPackage
    ({ makeSetupHook }:
      makeSetupHook
        { name = "mark-for-cudatoolkit-root-hook"; }
        ./hooks/mark-for-cudatoolkit-root-hook.sh)
    { });

  # Normally propagated by cuda_nvcc or cudatoolkit through their depsHostHostPropagated
  setupCudaPathsHook = (final.callPackage
    ({ makeSetupHook, backendStdenv }:
      makeSetupHook
        {
          name = "setup-cuda-paths-hook";
          substitutions.ccRoot = "${backendStdenv.cc}";
          substitutions.ccFullPath = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
        }
        ./hooks/setup-cuda-paths-hook.sh)
    { });

in
{
  inherit
    backendStdenv
    cudaFlags
    cudatoolkit
    markForCudatoolkitRootHook
    setupCudaPathsHook;

    # Arguments to ./stdenv.nix, exposed as attributes so they can be
    # overridden.
    #
    # Our goal is to link shared libraries to the host platform's most up-to-date libstdc++.
    # One exception is nvcc, which we link to the build platform's libstdc++.
    #
    # Verify by building
    # `.#pkgsCross.aarch64-multiplatform.cudaPackages.cuda_nvcc` and watching
    # for autopatchelf errors concerning libstdc++ and libgcc_s
    #
    # Cf. https://github.com/NixOS/nixpkgs/pull/225661#discussion_r1164564576
    gccForLibs = final.pkgs.stdenv.cc.cc;
    ccForStdenv = final.pkgs."${finalVersion.gcc}Stdenv".cc.cc;
    backendStdenvBase = final.pkgs.stdenv;

    saxpy = final.callPackage ./saxpy { };
}
