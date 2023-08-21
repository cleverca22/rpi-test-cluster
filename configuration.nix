inputs: { pkgs, lib, ... }:

{
  imports = [
    ./bootloader.nix
  ];
  boot = {
    loader.grub.enable = false;
    kernelParams = [
      "console=tty1"
      "kgdboc=ttyAMA0,115200"
      "drm.debug=0x4"
      #"console=ttyAMA0,115200"
    ];
    kernelPackages = pkgs.linuxPackages_rpi3;
    consoleLogLevel = 7;
  };
  documentation.enable = false;
  environment.systemPackages = with pkgs; [
    screen
    sysstat
    ncdu
    dtc
  ];
  nixpkgs = {
    overlays = [
      # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/development/modules/workarounds.nix
      (self: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
      inputs.self.overlays.default
    ];
  };
  hardware.opengl.enable = false;
  nix = {
    settings = {
      auto-optimise-store = true;
    };
  };
  services = {
    journald.extraConfig = ''
      MaxRetentionSec=0
    '';
    sshd.enable = true;
    nscd.enable = false;
    #gvfs.enable = lib.mkForce false;
    tumbler.enable = lib.mkForce false;
    xserver = {
      enable = false;
      #displayManager.slim.enable = true;
      desktopManager = {
        xfce.enable = true;
      };
    };
    # https://github.com/systemd/systemd/issues/13773
    # gdbus introspect --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1/seat/seat0
    udev.extraRules = ''
      SUBSYSTEM=="graphics", KERNEL=="fb[0-9]", TAG+="master-of-seat"
    '';
  };
  system.nssModules = lib.mkForce [];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "rw" ];
    };
  };
  networking = {
    firewall.enable = false;
    hostName = "pi3";
  };
}
