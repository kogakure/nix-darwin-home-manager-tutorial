# Nix Install and Setup on MacOS

This is following the tutorial [Walkthrough of Nix Install and Setup on MacOS](https://www.youtube.com/watch?v=LE5JR4JcvMg).

```sh
nix build .#darwinConfigurations.mac-mini.system

# Activate configuration (first time)
nix run nix-darwin -- switch --flake .

# Apply changes after first install
darwin-rebuild switch --flake .
```
