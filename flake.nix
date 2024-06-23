{
  description = "Example Darwin system flake";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Controls system level software and settings including fonts
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        nix.settings.experimental-features = "nix-command flakes";

        environment.shells = [ pkgs.bash pkgs.zsh ];
        environment.loginShell = pkgs.zsh;
        environment.systemPackages = [ pkgs.coreutils ];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToEscape = true;

        fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];

        services.nix-daemon.enable = true;

        programs.zsh.enable = true;

        system.defaults.finder.AppleShowAllExtensions = true;
        system.defaults.finder._FXShowPosixPathInTitle = true;
        system.defaults.dock.autohide = true;
        system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
        system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
        system.defaults.NSGlobalDomain.KeyRepeat = 1;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.kogakure = {
            home.stateVersion = "22.11";
            home.packages = with pkgs; [ ripgrep fd curl less ];
            home.sessionVariables = {
              PAGER = "less";
              CLICLOLOR = 1;
              EDITOR = "nvim";
            };
            programs.bat.enable = true;
            programs.bat.config.theme = "TwoDark";
            programs.fzf.enable = true;
            programs.fzf.enableZshIntegration = true;
            programs.eza.enable = true;
            programs.git.enable = true;
            programs.zsh.enable = true;
            programs.zsh.enableCompletion = true;
            programs.zsh.autosuggestion.enable = true;
            programs.zsh.syntaxHighlighting.enable = true;
            programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
            programs.starship.enable = true;
            programs.starship.enableZshIntegration = true;
            programs.alacritty = {
              enable = true;
              settings.font.normal.family = "MesloLGS Nerd Font Mono";
              settings.font.size = 16;
            };
          };
        };
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mac-mini
      darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."mac-mini".pkgs;
    };
}
