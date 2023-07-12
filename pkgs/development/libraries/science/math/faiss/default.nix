{ lib
, config
, fetchFromGitHub
, symlinkJoin
, stdenv
, buildPackages
, cmake
, cudaPackages ? { }
, cudaSupport ? config.cudaSupport or false
, nvidia-thrust
, useThrustSourceBuild ? true
, pythonSupport ? true
, pythonPackages
, llvmPackages
, boost
, blas
, swig
, addOpenGLRunpath
, optLevel ? let
    optLevels =
      lib.optionals stdenv.hostPlatform.avx2Support [ "avx2" ]
      ++ lib.optionals stdenv.hostPlatform.sse4_1Support [ "sse4" ]
      ++ [ "generic" ];
  in
  # Choose the maximum available optimization level
  builtins.head optLevels
, faiss # To run demos in the tests
, runCommand
}@inputs:

assert cudaSupport -> nvidia-thrust.cudaSupport;

let
  pname = "faiss";
  version = "1.7.4";

  inherit (cudaPackages) cudaFlags backendStdenv;
  inherit (cudaFlags) cudaCapabilities dropDot;

  stdenv = if cudaSupport then backendStdenv else inputs.stdenv;
in
stdenv.mkDerivation {
  inherit pname version;

  outputs = [ "out" "demos" ];

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WSce9X6sLZmGM5F0ZkK54VqpIy8u1VB0e9/l78co29M=";
  };

  buildInputs = [
    blas
    swig
  ] ++ lib.optionals pythonSupport [
    pythonPackages.setuptools
    pythonPackages.pip
    pythonPackages.wheel
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.cuda_nvcc # <crt/host_defines.h>
    cudaPackages.libcublas
    cudaPackages.libcurand

    # cuda_profiler_api.h
    (cudaPackages.cuda_profiler_api or cudaPackages.cuda_nvprof)
  ] ++ lib.optionals (cudaSupport && useThrustSourceBuild) [
    nvidia-thrust
  ] ++ lib.optionals (cudaSupport && !useThrustSourceBuild) [
    cudaPackages.cuda_cccl
  ];

  propagatedBuildInputs = lib.optionals pythonSupport [
    pythonPackages.numpy
  ];

  env.NIX_DEBUG = 6;

  nativeBuildInputs = [ cmake ] ++ lib.optionals cudaSupport [
    buildPackages.cudaPackages.cuda_nvcc
    cudaPackages.setupCudaPathsHook
    addOpenGLRunpath
  ] ++ lib.optionals pythonSupport [
    pythonPackages.python
  ];

  passthru.extra-requires.all = [
    pythonPackages.numpy
  ];

  preConfigure = ''
    echo CUDAToolkit_ROOT: $CUDAToolkit_ROOT
    echo CUDAToolkit_INCLUDE_DIR: $CUDAToolkit_INCLUDE_DIR
    echo buildInputs: $buildInputs
    echo CUDAHOSTCXX: $CUDAHOSTCXX
  '';

  cmakeFlags = [
    "-DFAISS_ENABLE_GPU=${if cudaSupport then "ON" else "OFF"}"
    "-DFAISS_ENABLE_PYTHON=${if pythonSupport then "ON" else "OFF"}"
    "-DFAISS_OPT_LEVEL=${optLevel}"
  ] ++ lib.optionals cudaSupport [
    "-DCMAKE_CUDA_ARCHITECTURES=${builtins.concatStringsSep ";" (map dropDot cudaCapabilities)}"
  ];


  # pip wheel->pip install commands copied over from opencv4

  buildPhase = ''
    make -j faiss
    make demo_ivfpq_indexing
  '' + lib.optionalString pythonSupport ''
    make -j swigfaiss
    (cd faiss/python &&
     python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .)
  '';

  installPhase = ''
    make install
    mkdir -p $demos/bin
    cp ./demos/demo_ivfpq_indexing $demos/bin/
  '' + lib.optionalString pythonSupport ''
    mkdir -p $out/${pythonPackages.python.sitePackages}
    (cd faiss/python && python -m pip install dist/*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache)
  '';

  fixupPhase = lib.optionalString (pythonSupport && cudaSupport) ''
    addOpenGLRunpath $out/${pythonPackages.python.sitePackages}/faiss/*.so
    addOpenGLRunpath $demos/bin/*
  '';

  # Need buildPythonPackage for this one
  # pythonImportsCheck = [
  #   "faiss"
  # ];

  passthru = {
    inherit cudaSupport cudaPackages pythonSupport;

    tests = {
      runDemos = runCommand "${pname}-run-demos"
        { buildInputs = [ faiss.demos ]; }
        # There are more demos, we run just the one that documentation mentions
        ''
          demo_ivfpq_indexing && touch $out
        '';
    } // lib.optionalAttrs pythonSupport {
      pytest = pythonPackages.callPackage ./tests.nix { };
    };
  };

  meta = with lib; {
    description = "A library for efficient similarity search and clustering of dense vectors by Facebook Research";
    homepage = "https://github.com/facebookresearch/faiss";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
