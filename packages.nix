{config, pkgs, ...}:{
  enviorment.systemPackages = with pkgs; [
    pciutils
    usbutils
    file
    unzip

  ];

}
