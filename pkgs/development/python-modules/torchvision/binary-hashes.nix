# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.16.0" = {
    x86_64-linux-38 = {
      name = "torchvision-0.16.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-lnwPitoqvu1DCzPoPOez3lIzZ1yLAgwYwSVdygZbSt0=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.16.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Xqi7p+gr+JRn5/h5BJnjwgyXx9DM13h4nM3S2ExkfJo=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.16.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-52540K1DY2yYhLMIT/rqioth8hEp+/pFal/nNPCv/qk=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.16.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-ejJScMeAZXHO3b0nyOzlwWPM60dvCdzKfrUVcHMhayI=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.16.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-DG820Auc5BLjZ61vQukFTLyJDNnd0NIA7Zs7Ut2cIls=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.16.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-3nxzAvovZ6KhUeWVqOfcOGWkRdlS6Z1caCunjzEv7cM=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.16.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-FsMA/bvpFGn16f7vjSTGrKvYhJ21AqBhYN12umjol6A=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.16.0-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-Mf3yib37KXb2WhT3n23dHuYBE9s0YiZ0kY5hUhwtxB8=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.16.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-WX9gywPm91igCzazhQb284tsPx/f05IbuavWC3LVIv0=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.16.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-8ETP/SUv0pO230bzjX7rL9T+kx4BFMUmNzXjuMnGCk8=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.16.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-713sbEi3FTU3gbg3Se/N6gODVyCnGzd2hEU+4Reqs8c=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.16.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-IpSmUUoxpv2lYiiLKM9ttXh3I39LVv9pMmLyN6ftQDU=";
    };
  };
}
