{ inputs, ... }@flakeContext:
let
  homeModule = { config, lib, pkgs, ... }: {
    config = {
      home = {
        homeDirectory = /Users/shivangswain;
        stateVersion = "25.05";
        username = "shivangswain";
      };
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
      programs = {
        git = {
          enable = true;
          signing = {
            key = "826FF286FEC7417A";
            signByDefault = true;
          };
          userEmail = "me@shivangswain.com";
          userName = "shivangswain";
        };
        gpg = {
          enable = true;
        };
        neovim = {
          defaultEditor = true;
          enable = true;
          extraLuaConfig = ''
            softtabstop = 2
            expandtab = true
          '';
        };
        vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles = {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;
              extensions = [
                pkgs.vscode-extensions.esbenp.prettier-vscode
                pkgs.vscode-extensions.ms-python.python
                pkgs.vscode-extensions.redhat.vscode-xml
                pkgs.vscode-extensions.redhat.vscode-yaml
                pkgs.vscode-extensions.visualstudioexptteam.intellicode-api-usage-examples
                pkgs.vscode-extensions.visualstudioexptteam.vscodeintellicode
                pkgs.vscode-extensions.vscodevim.vim
              ];
              userSettings = {
                "[css]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
                "[html]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
                "[typescript]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
                "editor.minimap.enabled" = false;
                "editor.tabSize" = 2;
                "git.confirmSync" = false;
                "git.enableCommitSigning" = true;
                "redhat.telemetry.enabled" = false;
                "update.mode" = "none";
                "workbench.activityBar.location" = "hidden";
              };
            };
          };
        };
        zsh = {
          autosuggestion = {
            enable = true;
          };
          enable = true;
          enableCompletion = true;
          initExtra = ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
          '';
          oh-my-zsh = {
            enable = true;
            plugins = [
              "cp"
              "fzf"
              "zoxide"
            ];
          };
          sessionVariables = {
            SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
          };
          syntaxHighlighting = {
            enable = true;
          };
        };
      };
      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          enableZshIntegration = true;
          pinentryPackage = pkgs.pinentry_mac;
          sshKeys = [
            "D3F75A53AAFBFEA33FF8E2F4A5927B868B1C8FBA"
          ];
        };
      };
    };
  };
  nixosModule = { ... }: {
    home-manager.users.shivangswain = homeModule;
  };
in
(
  (
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeModule
      ];
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    }
  ) // { inherit nixosModule; }
)
