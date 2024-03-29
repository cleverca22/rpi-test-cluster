{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rpi-open-firmware = {
      flake = false;
      url = "github:librerpi/rpi-open-firmware";
    };
  };
  outputs = { self, nixpkgs, rpi-open-firmware } @ inputs:
  {
    overlays.default = self: super: {
      inherit rpi-open-firmware;
      dtb_files = self.callPackage ./dtb_files.nix {};
    };
    packages = let
        mkImage = cross: let
          nativeModule = {
            nixpkgs.system = "aarch64-linux";
          };
          crossModule = {
            nixpkgs.crossSystem.system = "aarch64-linux";
          };
          archModule = if cross then crossModule else nativeModule;
          cfg = {
            imports = [ (import ./disk-image-config.nix inputs) archModule ];
          };
          eval = import "${nixpkgs}/nixos" { configuration = cfg; system = "aarch64-linux"; };
        in eval.config.system.build.sdImage;
      in {
      aarch64-linux = {
        inherit (nixpkgs.legacyPackages.aarch64-linux) sysstat screen;
        pi3-image = mkImage false;
      };
      x86_64-linux = let
        pkgs = nixpkgs.legacyPackages.x86_64-linux.extend self.overlays.default;
      in {
        lk-overlay-src = pkgs.callPackage ./lk-src.nix {};
        pi3-image = mkImage true;
      };
    };
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };
      pi3 = { pkgs, lib, ... }:
      {
        imports = [
          (import ./configuration.nix inputs)
        ];
        deployment = {
          targetHost = "10.0.0.108";
        };
      };
    };
  };
}
