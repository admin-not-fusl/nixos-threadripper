
{config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # compilers
    gcc
    clang
    clang-tools        # clangd, clang-format, clang-tidy
    lld
    mold               # fast linker

    # build systems
    cmake
    ninja
    meson
    pkg-config
    gnumake

    # debuggers / profilers
    gdb
    lldb
    valgrind
    perf-tools
    linuxPackages_latest.perf
    renderdoc          # GPU frame capture

    # vcs and friends
    git
    git-lfs
    gh
    delta              # better diffs
    # python for scripts/Maya tooling
    python3
  ];

  # Per-project environments load automatically when you cd in
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Lets foreign binaries (vendor SDKs, prebuilt tools) run by giving them
  # a fake dynamic linker path. Not needed for anything built with Nix.
  programs.nix-ld.enable = true;

}
