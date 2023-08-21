inputs: { pkgs, config, ... }:

let
  lk-src = pkgs.callPackage ./lk-src.nix {};
  lk = import lk-src {};
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
    (import ./configuration.nix inputs)
  ];
  sdImage = {
    compressImage = true;
    populateRootCommands = ''
      pwd
      mkdir files/boot
      ls files
      cp ${lk.vc4.vc4.stage2}/lk.elf files/boot/lk.elf
      PREFIX=files ${config.system.build.installBootLoader} ${config.system.build.toplevel}
    '';
    populateFirmwareCommands = ''
      pwd
      ls
      cp ${lk.vc4.vc4.stage1}/lk.bin firmware/bootcode.bin
    '';
  };
}
