
{config, pkgs, ...}:{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_7_1;
  boot.kernelParams = [
      # amd
      "amd_pstate=active"
      "amd_iommu=on"
      "iommu=pt"

      # power management
      "pcie_aspm=off"
      "usbcore.autosuspend=-1"
      "nvme_core.default_ps_max_latency_us=0"

      # memory
      "hugepagesz=1G" "hugepages=24"

    ];

    boot.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];

    boot.kernel.sysctl."vm.swappiness" = 10;

    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
      extraConfig = {
        DefaultMemoryPressureDurationSec = "20s";
      };
    };

}
