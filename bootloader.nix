{ pkgs, ... }:

{
  options = {};
  config = {
    system.boot.loader.id = "openpi";
    system.build.installBootLoader = pkgs.substituteAll {
      src = ./install-openpi.sh;
      name = "install-openpi.sh";
      isExecutable = true;
      crossShell = pkgs.runtimeShell;
      inherit (pkgs) dtb_files;
    };
  };
}
