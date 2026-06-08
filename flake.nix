{
  description = "Nix configuration for macOS with nix-darwin and home-manager";

  inputs = {
    # Main nixpkgs repository (unstable channel for latest packages)
    nixpkgs.url = "flake:nixpkgs/nixpkgs-26.05-darwin";

    # nix-darwin for macOS system configuration
    nix-darwin = {
      url = "flake:nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager for user-level configuration
    home-manager = {
      url = "flake:home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      # Context passed to configuration modules
      flakeContext = {
        inherit inputs;
      };
    in
    {
      # macOS system configurations managed by nix-darwin
      darwinConfigurations = {
        macos = import ./darwinConfigurations/macos.nix flakeContext;
      };

      # Standalone home-manager configurations (can be used independently)
      homeConfigurations = {
        shivangswain = import ./homeConfigurations/shivangswain.nix flakeContext;
      };
    };
}
