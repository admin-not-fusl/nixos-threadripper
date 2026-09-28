
{config, pkgs, ...}:{
  networking.hostName = "Fuzl-threadripper";
  networking.networkmanager.enable = true;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # add exceptions here, probably should leave no ports open

  };

  services.avahi = {
    enable = false;

  };

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];
  #TODO(Katie): point to local dns for better security

  networking.networkmanager.wifi.backend = "iwd";

}
