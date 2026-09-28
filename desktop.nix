# plasma.nix
#
# Plasma 6 on Wayland via SDDM. Fcitx5 input method config lives in
# locale.nix; fonts too. This is the desktop shell itself.

{ config, pkgs, ... }:

{
  # Login manager, Wayland session for it too
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "plasma";   # Wayland session (plasmax11 is the other)

  services.desktopManager.plasma6.enable = true;

  # Default Plasma package set is large; drop what you won't use.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa          # music player
    khelpcenter
    oxygen         # old theme set
    plasma-browser-integration
  ];

  # Apps that are oddly not in the default set
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.ark
    kdePackages.filelight
    kdePackages.kcalc
    kdePackages.spectacle        # screenshots
    kdePackages.partitionmanager
    kdePackages.fcitx5-configtool  # input method settings in System Settings
    firefox
    vlc
    mpv
  ];

  # Portals: file pickers, screen sharing, Flatpak integration on Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };
  services.flatpak.enable = true;

  # Plasma's own services that are off by default and worth having
  services.power-profiles-daemon.enable = true;   # performance / balanced toggle in the tray
  programs.dconf.enable = true;                   # GTK apps read settings via dconf
  programs.kdeconnect.enable = false;             # you said no listeners; flip if wanted

  # Wayland hints for the rest of the stack
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";        # Electron/Chromium apps (VRCX, Discord, VS Code) run native Wayland
    QT_QPA_PLATFORM = "wayland;xcb";   # Qt prefers Wayland, falls back to XWayland
  };

  # Keyboard in Plasma follows xkb from locale.nix; nothing needed here.

  # Printing (CUPS) — no ports opened, local printers only
  services.printing.enable = true;
}
