# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.0" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.1.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-Uay0aJp7AfJY4xruybmofoSDdCJhvRHhL4BzTIiM3og=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.1.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-gRSabpm/56lsu4efT8M/5GmJq5VOBJuajuu77OPyp70=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.1.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-Z2vaQEJzTtqZvFmy1/dh80XTzeDK1JKtNOOu/eaIxtg=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.1.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-cCgt5XVqM96W3KHMW2jrlY32nVrviGmIBAPgl9sf8JE=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.1.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-bdWTMYgVTLi9nmNMeBIYbB3zgqa1175HHolPtIimdX4=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.1.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-NJ97HChyREX8Rg8uyfYGMaWjNd+uutNplL0RziIFax4=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.1.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-RF66BE1w4pKsqypndj7mgq+Md20tDKZxzb5DujlkIqM=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.1.0-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-i9Hu9Tw1POp+tsvhATy9nlHEiYfhnQa9uymiKEa4xrE=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.1.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-lqY1Egxt01kmqv4fILuvUyXHdYEwgoMt3m3zkMyL6Q4=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.1.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-7ZL1nYhjV4KYs/I4z8bEx0JRWYyeRkIkZzG6C4BDoDM=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.1.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-zW8px4NYtjL/cSOSnlNY298FBYSYEbV+cQjL0q9Cu0Q=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.1.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-/JcYKrqyBl2Lv1bzcyiD5ArPz+w48lgcl3ELH8qTxKc=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.1.0-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-CjN9sdXxNNIWiHDqC8AmEHrw/h6ArX2T3uAC2q5f42M=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.1.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-ZTAW1ZQB4fhEEui3aWCGb0rrikA+Ok0E1cmlW2fegls=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.1.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-AQ9j/nZnh+BYmJ/63Xk9qt2UbOHekDvhcQh5OM29wdc=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.1.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-Mo5fNoMOiGwrbyo1hohYqkZLnBquPIfXCytPrDchuCI=";
    };
  };
}
