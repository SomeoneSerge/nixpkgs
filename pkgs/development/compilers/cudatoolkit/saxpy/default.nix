{ backendStdenv
, buildPackages
, cmake
, cuda_cccl ? null # Missing in cuda 11.4
, cuda_cudart
, cudaFlags
, cuda_nvcc
, cudaVersion
, lib
, libcublas ? null
, setupCudaPathsHook
, stdenv
, autoAddOpenGLRunpathHook
}:

backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  buildInputs = [
    cuda_cudart
  ] ++ lib.optionals (lib.versionOlder "11.4" cudaVersion) [
    cuda_cccl # <nv/target>
    libcublas
  ];
  nativeBuildInputs = [
    cmake
    buildPackages.cudaPackages.cuda_nvcc
    # Alternatively, we could remove the propagated hook from cuda_nvcc and add
    # directly:
    # setupCudaPathsHook
    autoAddOpenGLRunpathHook
  ];

  preConfigure = ''
    echo "enter: env"
    env
    echo "exit: env"
  '';

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DCMAKE_CUDA_ARCHITECTURES=${with cudaFlags; builtins.concatStringsSep ";" (map dropDot cudaCapabilities)}"
  ];

  meta = {
    description = "A simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = lib.platforms.unix;
  };
}
