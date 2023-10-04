# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.0" = {
    x86_64-linux-38 = {
      name = "torch-2.1.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-TIMZCtZJx3ra9uHGFpmPEFmNtpaRLqekEIMWMokLSb8=";
    };
    x86_64-linux-39 = {
      name = "torch-2.1.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-lLYK51Yq5zJVSuh0QSOzPUbmWcMlGlpYxyacEug4hos=";
    };
    x86_64-linux-310 = {
      name = "torch-2.1.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-DU6MUqH89e1s/CVtmjcPz0NglY/HnQsIpR1V5wkU30Y=";
    };
    x86_64-linux-311 = {
      name = "torch-2.1.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-qphFmcLE/7xXxI0Nlly+gy5hDJZ+gXnUrApYLHM/4RI=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.1.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-yL9+r5UURl5dkQHgUZUYNHCmIVu1ApXGG1IwKgTttpA=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.1.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-atSR5w2+QojRf9v8f7+nZtZsviGbxIcceoCW9KN8mN8=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.1.0-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-EBwTkVKVnLIKs3D8GSZyxQCTdHkG7kzqzkTY3XA/Ka8=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.1.0-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-YBsKKp2SM/tLgffUfcqWgNTzp4yj94EHi2rRztipBSM=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.1.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-BWYcMuwUvDoVcZPQ8Zp7GdjmHreHszNTytMCAsKV6Ds=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.1.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-Qhc5aF66XgvrpCy2SXQLFdRLDVZcBObtZntBFIc0p1s=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.1.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-prdDipCocOTN6xUwFRmubAQ8iD/NIk0wPFsRgIKBR2c=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.1.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-PNHe3/E4hNiQ8Y7qYgGE+0zY/TxozjMASY9Ceuk6qWI=";
    };
    aarch64-linux-38 = {
      name = "torch-2.1.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-dhgidh//qhwYpixd6xOrqngIYld9Pq3EKPHapjJTaQU=";
    };
    aarch64-linux-39 = {
      name = "torch-2.1.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-3n1jxuzs4RhoRBWj29SAWvSkwe4UkMzPdAXYwkCkgbQ=";
    };
    aarch64-linux-310 = {
      name = "torch-2.1.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-oEoCltR/KJYPUcGMVImow0cvYk7DtbzI4gljFN+MM0I=";
    };
    aarch64-linux-311 = {
      name = "torch-2.1.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-gTLvt4LNGBzC3MpeWO/75CF82yWBIGrHFGbVNb93iGc=";
    };
  };
}
