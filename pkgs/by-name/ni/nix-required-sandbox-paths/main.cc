#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include <cxxopts.hpp>
#include <nlohmann/json.hpp>

#include "config.h"

using json = nlohmann::json;
using namespace std;

struct Conf {
  string nixPath;
  vector<string> allowedPatterns;

  static Conf fromString(const string &s) {
    Conf conf;
    nlohmann::json j;
    std::stringstream ss(s);
    ss >> j;
    j.at("nixPath").get_to(conf.nixPath);
    j.at("allowedPatterns").get_to(conf.allowedPatterns);
    return conf;
  }
};

int main(int argc, char **argv) {

  const auto conf = Conf::fromString(CONF_JSON);

  cxxopts::Options options("nix-required-sandbox-paths",
                           "A --pre-build-hook for Nix");
  // clang-format off
  options.add_options()
      ("drvPath", "Path to the .drv being realised", cxxopts::value<string>())
      ("sandboxPath", "blah blah", cxxopts::value<optional<string>>())
      ("N,no-linefeed", "Omit the final \\n which terminates the hook", cxxopts::value<bool>()->default_value("false"))
      ("h,help", "Print usage");
  // clant-format on

  options.parse_positional({"drvPath", "sandboxPath"});
  options.positional_help("drvPath [sandboxPath]");

  auto result = options.parse(argc, argv);

  if (result.count("help")) {
      std::cout << options.help() << std::endl;
      exit(0);
  }

  const string drvPath = result["drvPath"].as<string>();


  return 0;
}
