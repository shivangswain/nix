{
  description = "";
  inputs = {
    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "flake:nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      darwinConfigurations = {
        macos = import ./darwinConfigurations/macos.nix flakeContext;
      };
      homeConfigurations = {
        shivangswain = import ./homeConfigurations/shivangswain.nix flakeContext;
      };
    };
}
