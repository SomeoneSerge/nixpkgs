cmake_minimum_required(VERSION 3.20)
project(nix-required-sandbox-paths LANGUAGES CXX)

option(NIX_EXE "Path to the nix executable")

find_package(nlohmann_json 3.11 REQUIRED)
find_package(cxxopts 3 REQUIRED)

add_executable(nix-required-sandbox-paths main.cc)
target_link_libraries(nix-required-sandbox-paths
                      PRIVATE nlohmann_json::nlohmann_json)
target_include_directories(nix-required-sandbox-paths PRIVATE .)
target_compile_definitions(nix-required-sandbox-paths
                           PRIVATE -DNIX_EXE="${NIX_EXE}")

install(TARGETS nix-required-sandbox-paths)
