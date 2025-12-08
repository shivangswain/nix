# Nix Configuration for macOS

Declarative macOS system configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Overview

This flake manages:

- **System packages** via nixpkgs and Homebrew
- **GUI applications** via Homebrew Casks
- **Mac App Store apps** via `mas`
- **macOS system preferences** (Dock, Finder, keyboard, etc.)
- **User environment** (shell, Git, VS Code, GPG, etc.)

## Prerequisites

- macOS on Apple Silicon (aarch64-darwin)
- [Nix package manager](https://nixos.org/download.html) with flakes enabled

### Installing Nix

The recommended way to install Nix on macOS is using the [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer):

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --prefer-upstream-nix
```

This installer:

- Enables flakes and the unified CLI by default
- Stores a receipt for easy uninstallation
- Works seamlessly with nix-darwin

## Usage

Update flake inputs and apply the configuration:

```sh
nix flake update --flake ~/.config/nix

sudo darwin-rebuild switch --flake ~/.config/nix#macos
```

## Structure

```sh
~/.config/nix/
├── flake.nix                  # Flake definition and inputs
├── darwinConfigurations/
│   └── macos.nix              # System-level configuration
└── homeConfigurations/
    └── shivangswain.nix       # User-level configuration
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
