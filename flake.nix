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

    # Tricked out nvim
    pwnvim.url = "github:zmre/pwnvim";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, pwnvim }:
    let
      configuration = { config, pkgs, ... }: {
        imports = [
          ./modules/darwin
          ./modules/home-manager
        ];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.kogakure = { };
          extraSpecialArgs = { inherit pwnvim; };
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
        specialArgs = { inherit pwnvim; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."mac-mini".pkgs;
    };
}
