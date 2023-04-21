{ lib
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "lit";
  version = "16.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YwpHKRtxTLEVAV3yOrBCZ8JP5Zrsfs1+Y31cdc20XJE=";
  };

  doCheck = false;

  meta = with lib; {
    description = "lit is a portable tool for executing LLVM and Clang style test suites, summarizing their results, and providing indication of failures";
    homepage = "https://github.com/llvm/llvm-project/tree/main/llvm/utils/lit";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
