{ config, pkgs, pwnvim, ... }:

{
  home-manager = {
    users.kogakure = {
      home = {
        stateVersion = "22.11";
        packages = with pkgs; [
          ripgrep
          fd
          curl
          less
          pwnvim.packages."aarch64-darwin".default
        ];
        sessionVariables = {
          PAGER = "less";
          CLICLOLOR = 1;
          EDITOR = "nvim";
        };

        file.".inputrc".source = ./dotfiles/inputrc;
      };

      programs = {
        bat = {
          enable = true;
          config.theme = "TwoDark";
        };
        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        eza.enable = true;
        git.enable = true;
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = {
            ls = "ls --color=auto -F";
            nixswitch = "darwin-rbuild switch --flake ~/.dotfiles/.#";
            nixup = "pushd ~/.dotfiles; nix flake update; nixswitch; popd";
          };
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
        };
        alacritty = {
          enable = true;
          settings.font.normal.family = "MesloLGS Nerd Font Mono";
          settings.font.size = 16;
        };
      };
    };
  };
}
