
{config, pkgs, ...}: {
  fileSystems."/".options        = [ "noatime" "ssd" "discard=async" ];
  fileSystems."/home".options    = [ "noatime" "ssd" "discard=async" ];
  fileSystems."/nix".options     = [ "noatime" "ssd" "discard=async" ];
  fileSystems."/scratch".options = [ "noatime" "ssd" "discard=async" "nodatacow" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];

  };

  # this here because of dicsard up there in the options
  services.fstrim.enable = false;

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";
  zramSwap.enable = false;

  environment.systemPackages = with pkgs; [
    btrfs-progs      # btrfs subvolume / device / balance / scrub
    compsize         # actual on-disk usage per subvolume
    nvme-cli         # nvme smart-log, firmware, temps
    smartmontools    # smartctl for the eventual 8 TB drive
  ];

  # scratch space perms
  systemd.tmpfiles.rules = [ "d /scratch 0755 fuzl users -" ];

}
