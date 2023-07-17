{ backendStdenv
, buildPackages
, cmake
, cuda_cccl
, cuda_cudart
, cudaFlags
, cuda_nvcc
, lib
, libcublas
, setupCudaPathsHook
, stdenv
, autoAddOpenGLRunpathHook
}:

backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  buildInputs = [
    libcublas
    cuda_cudart
    cuda_cccl
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
    echo "begin{env}"
    env
    echo "end{env}"
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
