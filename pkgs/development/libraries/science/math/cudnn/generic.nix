{ stdenv
, lib
, zlib
, autoPatchelfHook
, cudaPackages
, fetchurl
, addOpenGLRunpath
, # The distributed version of CUDNN includes both dynamically liked .so files,
  # as well as statically linked .a files.  However, CUDNN is quite large
  # (multiple gigabytes), so you can save some space in your nix store by
  # removing the statically linked libraries if you are not using them.
  #
  # Setting this to true removes the statically linked .a files.
  # Setting this to false keeps these statically linked .a files.
  removeStatic ? false
}:

{ fullVersion
, url
, hash ? null
, sha256 ? null
, supportedCudaVersions ? []
}:

assert (hash != null) || (sha256 != null);

let
  inherit (cudaPackages) cudaMajorVersion libcublas;
  inherit (cudaPackages.cudatoolkit ) cc;

  majorMinorPatch = version: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version));
  version = majorMinorPatch fullVersion;
in stdenv.mkDerivation {
  name = "cudatoolkit-${cudaMajorVersion}-cudnn-${version}";

  inherit version;
  # It's often the case that the src depends on the version of cudatoolkit it's
  # being linked against, so we pass in `cudatoolkit` as an argument to `mkSrc`.
  src = fetchurl {
    inherit url hash sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook addOpenGLRunpath ];

  # Some cuDNN libraries depend on things in cudatoolkit, eg.
  # libcudnn_ops_infer.so.8 tries to load libcublas.so.11. So we need to patch
  # cudatoolkit into RPATH. See also https://github.com/NixOS/nixpkgs/blob/88a2ad974692a5c3638fcdc2c772e5770f3f7b21/pkgs/development/python-modules/jaxlib/bin.nix#L78-L98.
  #
  # Note also that version <=8.3.0 contained a subdirectory "lib64/" but in
  # version 8.3.2 it seems to have been renamed to simply "lib/".
  installPhase = ''
    runHook preInstall

    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "''${p:+$p:}${lib.makeLibraryPath [ cc.cc libcublas zlib ]}:\$ORIGIN/" $1
    }

    for sofile in {lib,lib64}/lib*.so; do
      fixRunPath $sofile
    done

    mkdir -p $out
    cp -a include $out/include
    [ -d "lib/" ] && cp -a lib $out/lib
    [ -d "lib64/" ] && cp -a lib64 $out/lib64
  '' + lib.optionalString removeStatic ''
    rm -f $out/lib/*.a
    rm -f $out/lib64/*.a
  '' + ''
    runHook postInstall
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  #
  # Running in installCheckPhase because it should go after autoPatchelf's postFixup
  doInstallCheck = true;
  installCheckPhase = ''
    addOpenGLRunpath $out/lib/lib*.so
  '';

  passthru = {
    cudatoolkit = lib.warn "cudnn.cudatoolkit passthru attribute is deprecated: use cudaPackages" cudaPackages.cudatoolkit;
    inherit cudaPackages;

    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    # Check that the cudatoolkit version satisfies our min/max constraints (both
    # inclusive). We mark the package as broken if it fails to satisfies the
    # official version constraints (as recorded in default.nix). In some cases
    # you _may_ be able to smudge version constraints, just know that you're
    # embarking into unknown and unsupported territory when doing so.
    broken = !(elem cudaPackages.cudatoolkit.majorMinorVersion supportedCudaVersions);
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter samuela ];
  };
}
