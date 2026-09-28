{config, pkgs, ...}:{
  users.users.fuzl = {
    isNormalUser = true;
    description = "Fuzl";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" "kvm" "dialout" ];
    autoSubUidGidRange = true; # rootless podman / distrobox, useful to install maya
  };

}
