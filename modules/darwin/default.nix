{ config, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";

  environment.shells = [ pkgs.bash pkgs.zsh ];
  environment.loginShell = pkgs.zsh;
  environment.systemPackages = [ pkgs.coreutils ];
  environment.systemPath = [ "/opt/homebrew/bin" ];
  environment.pathsToLink = [ "/Applications" ];

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

  system.stateVersion = 4;

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    taps = [ "fujiapples852/trippy" ];
    masApps = { };
    casks = [ "raycast" "amethyst" ];
    brews = [ "trippy" ];
  };
}
