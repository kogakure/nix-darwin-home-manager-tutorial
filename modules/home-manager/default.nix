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

        file.".inputrc".text = ''
          set show-all-if-ambiguous on
          set completion-ignore-case on
          set mark-directories on
          set mark-symlinked-directories on
          set match-hidden-files off
          set visible-stats on
          set keymap vi
          set editing-mode vi-insert
        '';
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
          shellAliases = { ls = "ls --color=auto -F"; };
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
