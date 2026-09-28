{ config, pkgs, ... }:

{
  # Mesa / GL / Vulkan userspace plumbing. Needed regardless of vendor.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;                     # 32-bit Vulkan/GL for Steam & Wine
    extraPackages = with pkgs; [
      nvidia-vaapi-driver                   # VA-API video decode in Firefox/mpv on NVIDIA
    ];
  };

  # Selects the proprietary driver and blacklists nouveau automatically.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;                            # open kernel modules; the 5090 needs GSP
    modesetting.enable = true;              # KMS — required for Wayland / KWin
    powerManagement.enable = false;         # desktop; suspend not in use
    powerManagement.finegrained = false;    # laptop-only feature
    nvidiaSettings = true;                  # nvidia-settings GUI
    nvidiaPersistenced = false;             # must be off so the A4500 can unbind to a VM
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Environment hints so apps pick the NVIDIA paths on Wayland.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";           # VA-API → nvidia-vaapi-driver
    NVD_BACKEND = "direct";                 # required by nvidia-vaapi-driver on 5xx+ drivers
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";   # GLX under XWayland uses the NVIDIA libGL
    # Pin KWin to the 5090 so the A4500 stays free for the VM.
    # Get the path from `ls -l /dev/dri/by-path/` after first boot, then uncomment.
    # KWIN_DRM_DEVICES = "/dev/dri/by-path/pci-0000:XX:00.0-card";
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia    # GPU top
    vulkan-tools            # vulkaninfo, vkcube
    libva-utils             # vainfo — check VA-API decode works
  ];

  # CUDA-built nixpkgs packages (Blender, OpenCV, PyTorch…). Off until wanted:
  # long from-source builds unless the cuda-maintainers cache is configured in nix.nix.
  # nixpkgs.config.cudaSupport = true;
}
