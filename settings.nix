
{config, pkgs, ...}: {
  nix.settings = {
    # `nix build`, `nix run`, `nix shell` (the new CLI) and flakes.
    # Both still "experimental" on paper; everyone uses them.
    experimental-features = [ "nix-command" "flakes" ];

    # Hardlink identical files across store paths. Halves store growth
    # over time; small CPU cost on each write to the store.
    auto-optimise-store = true;

    # Parallelism: how many derivations build at once, and cores per build.
    # 0 cores = "all of them". On 32 cores, auto usually picks 32 jobs.
    max-jobs = "auto";
    cores = 0;

    # Who may add binary caches / change settings without editing this file.
    # @wheel lets your user use `--option substituters` on the command line.
    trusted-users = [ "root" "@wheel" ];

    # Keep build-time dependencies and sources when GC runs. Means a
    #    # `nix develop` shell for your engine doesn't get its toolchain collected
    # out from under it. Costs disk you have.
    keep-outputs = true;
    keep-derivations = true;

    # Bigger download buffer for 10GbE; default is 64 MB and warns on big paths.
    download-buffer-size = 1073741824;

    # Warn if a git-tracked config has uncommitted changes when building a flake.
    warn-dirty = false;
  };

}
