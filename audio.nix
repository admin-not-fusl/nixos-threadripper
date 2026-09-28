
{config, pkgs, ...}:{
  boot.kernelParams = [
    "preempt=full"
    "threadirqs"

  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;            # 32-bit games / Wine
    pulse.enable = true;                 # Pulse API for desktop apps
    jack.enable = true;                  # JACK API for DAWs / plugin hosts

    # Graph clock. 128 @ 48 kHz ≈ 2.7 ms per period.
    # allowed-rates lets a DAW switch the graph to its project rate
    # instead of PipeWire resampling.
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate"          = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
        "default.clock.quantum"       = 256;
        "default.clock.min-quantum"   = 32;
        "default.clock.max-quantum"   = 1024;

      };

    };

    wireplumber.extraConfig = {

      # Bluetooth: codec whitelist + quality-of-life
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq"    = true;
          "bluez5.enable-msbc"      = true;    # wideband mic on calls
          "bluez5.enable-hw-volume" = true;
          # Whitelist, not priority. XM6 → LDAC, M50xBT → aptX / AAC.
          "bluez5.codecs" = [ "ldac" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc" ];
          "bluez5.roles"  = [ "a2dp_sink" "a2dp_source" "hfp_hf" "hfp_ag" ];

        };

      };

      # Hide the NVIDIA HDMI/DP audio sinks — two cards, ~8 useless outputs.
      # Delete this block if you ever want audio over DisplayPort to a monitor.
      "52-hide-nvidia-hdmi" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "device.name" = "~alsa_card.pci-.*"; "device.vendor.name" = "~NVIDIA.*"; }

            ];

            actions.update-props = { "device.disabled" = true; };

          }

        ];

      };

    };

  };

  # Realtime limits for the audio group (DAW threads, not just PipeWire)
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nice";    type = "-"; value = "-19"; }

  ];

  # Bluetooth stack
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true;       # battery reporting for the headsets
      FastConnectable = true;

    };

  };

  # Tools (pw-top and wpctl ship with pipewire itself)
  environment.systemPackages = with pkgs; [
    pavucontrol      # the honest view of sinks/sources/profiles
    qpwgraph         # patchbay — needed with the pro-audio profile

  ];

}
