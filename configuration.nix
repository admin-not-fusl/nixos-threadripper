
{config, pkgs, ...}:{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./networking.nix
    ./locale.nix
    ./fuzl.nix
    ./propriatary.nix
    ./audio.nix
    ./mount.nix
    ./shell.nix
    ./nvidia.nix
    ./toolchain_global.nix
    ./unfree.nix
    ./settings.nix
    ./desktop.nix
    ./packages.nix

  ];

  system.stateVersion = "26.05";

}
