{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, pythonOlder
, addOpenGLRunpath
, pynvml
}:

buildPythonPackage rec {
  pname = "pynvml";
  version = "11.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0CeyG5WxCIufwngRf59ht8Z/jjOnh+n4P3NfD3GsMtA=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
      inherit (addOpenGLRunpath) driverLink;
    })
  ];

  doCheck = false;
  passthru.tests.testNvmlInit = pynvml.overridePythonAttrs (_: {
    checkPhase = ''
      python3 << \EOF
      import pynvml
      from pynvml.smi import nvidia_smi

      try:
          print("enter: nvmlInit")
          print(f"{pynvml.nvmlInit()=}")
      except Exception as e:
          print(e)
          raise
      finally:
          print("exit: nvmlInit")
      EOF
    '';
    doCheck = true;
    requiredSystemFeatures = [ "expose-cuda" ];
  });

  pythonImportsCheck = [ "pynvml" "pynvml.smi" ];

  meta = with lib; {
    description = "Python bindings for the NVIDIA Management Library";
    homepage = "https://www.nvidia.com";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
