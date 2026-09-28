{config, pkgs, ...}:{
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    file
    unzip

  ];

}
