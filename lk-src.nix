{ fetchFromGitHub }:

fetchFromGitHub {
  name = "lk-overlay-src";
  owner = "librerpi";
  repo = "lk-overlay";
  rev = "c62f1e4646a49d3e2e10fa06830e40651d93d88a";
  fetchSubmodules = true;
  sha256 = "sha256-FXoPc2lGk7MJTwtSnuXb0qayaFKsGQAdJmnvGEDg/e8=";
}
