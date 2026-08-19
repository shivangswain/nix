{
  description = "Nix configuration for macOS with nix-darwin and home-manager";

  inputs = {
    # nixpkgs unstable channel for macOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin for macOS system configuration
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
