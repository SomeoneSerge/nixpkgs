{ addOpenGLRunpath
, cmake
, conf ? {
    allowedPatterns = [
      addOpenGLRunpath.driverLink
      "/ipfs"
      "/dev/video*"
      "/dev/dri"
    ];
    nixPath = lib.getExe nix;
  }
, cxxopts
, formats
, pkg-config
, lib
, nix
, nlohmann_json
, stdenv
}:

stdenv.mkDerivation {
  pname = "nix-required-sandbox-paths";
  version = "0.0.1";
  src = ./.;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cxxopts
    nlohmann_json
    nix.dev
  ];

  confJson = (formats.json { }).generate "config.json" conf;
  preConfigure = ''
    echo 'std::string CONF_JSON = R"JSON(' > config.h
    cat $confJson >> config.h
    echo ')JSON";' >> config.h
  '';

  meta = with lib; {
    description = "A pre-build-hook for Nix that exposes paths to the sandbox based on requiredSystemFeatures";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/nix-required-sandbox-paths";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
    platforms = platforms.linux;
  };
}
