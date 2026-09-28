
{config, pkgs, ...}:{


  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

}
