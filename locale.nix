
{config, pkgs, ...}:{
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "ja_JP.UTF-8";
  };
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];

  # desktop keymap
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # japanese IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk           # GTK apps (Firefox, Steam)
      kdePackages.fcitx5-qt  # Qt apps (Plasma, Maya's file dialogs)
    ];
    fcitx5.waylandFrontend = true;
  };

  # fonts
  #TODO(Katie): I need to import helvetica neue here so i can have cleaner ui
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono   # terminal / editor
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
      serif     = [ "Noto Serif" "Noto Serif CJK JP" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };

}
