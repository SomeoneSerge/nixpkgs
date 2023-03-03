final: prev: let
  ### Cuda Toolkit

  # Function to build the class cudatoolkit package
  buildCudaToolkitPackage = final.callPackage ./common.nix;

  # Version info for the classic cudatoolkit packages that contain everything that is in redist.
  cudatoolkitVersions = final.lib.importTOML ./versions.toml;

  finalVersion = cudatoolkitVersions.${final.cudaVersion};

  # Exposed as cudaPackages.backendStdenv.
  # We don't call it just "stdenv" to avoid confusion: e.g. this toolchain doesn't contain nvcc.
  # Instead, it's the back-end toolchain for nvcc to use.
  # We also use this to link a compatible libstdc++ (backendStdenv.cc.cc.lib)
  backendStdenv = prev.pkgs."${finalVersion.gcc}Stdenv";

  ### Add classic cudatoolkit package
  cudatoolkit = buildCudaToolkitPackage (finalVersion // { inherit backendStdenv; });

  cudaFlags = final.callPackage ./flags.nix { };

in
{
  inherit
    backendStdenv
    cudatoolkit
    cudaFlags;
}
