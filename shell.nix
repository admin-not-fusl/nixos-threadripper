{config, pkgs, ...}: {
  programs.fish = {
    enable = true;

    # Runs for every interactive fish. Keep it small; per-user stuff can go in
    # ~/.config/fish/config.fish or home-manager later.
    interactiveShellInit = ''
      set -g fish_greeting                 # no "Welcome to fish" banner
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';

    shellAbbrs = {
      # nixos
      nrs  = "sudo nixos-rebuild switch";
      nrt  = "sudo nixos-rebuild test";
      nrb  = "sudo nixos-rebuild boot";

      # git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate -20";

      # misc
      ll = "ls -lah";

    };

  };

  programs.bash.interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';

  environment.systemPackages = with pkgs; [
    fzf          # fuzzy history/file search; fish picks it up automatically
    eza          # modern ls
    ripgrep
    fd
    bat
  ];

}
