{ inputs, ... }@flakeContext:
let
  homeModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        home = {
          homeDirectory = /Users/shivangswain;
          stateVersion = "25.05";
          username = "shivangswain";
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
            profiles = {
              default = {
                enableExtensionUpdateCheck = true;
                enableUpdateCheck = true;
                extensions = [
                  pkgs.vscode-extensions.astro-build.astro-vscode
                  pkgs.vscode-extensions.bradlc.vscode-tailwindcss
                  pkgs.vscode-extensions.eamodio.gitlens
                  pkgs.vscode-extensions.esbenp.prettier-vscode
                  pkgs.vscode-extensions.github.copilot
                  pkgs.vscode-extensions.github.copilot-chat
                  pkgs.vscode-extensions.github.github-vscode-theme
                  pkgs.vscode-extensions.jnoortheen.nix-ide
                  pkgs.vscode-extensions.ms-python.python
                  pkgs.vscode-extensions.redhat.vscode-xml
                  pkgs.vscode-extensions.redhat.vscode-yaml
                  pkgs.vscode-extensions.visualstudioexptteam.intellicode-api-usage-examples
                  pkgs.vscode-extensions.visualstudioexptteam.vscodeintellicode
                  pkgs.vscode-extensions.vscodevim.vim
                  pkgs.vscode-extensions.wix.vscode-import-cost
                ];
                userSettings = {
                  "[python]" = {
                    "editor.codeActionsOnSave" = {
                      "source.organizeImports" = "explicit";
                    };
                  };
                  "chat.agent.enabled" = true;
                  "editor.cursorSmoothCaretAnimation" = "on";
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                  "editor.formatOnSave" = true;
                  "editor.tabSize" = 2;
                  "editor.wordWrap" = "on";
                  "git.autofetch" = true;
                  "git.confirmSync" = false;
                  "git.enableCommitSigning" = true;
                  "redhat.telemetry.enabled" = false;
                  "update.mode" = "none";
                  "workbench.activityBar.location" = "hidden";
                  "workbench.colorTheme" = "GitHub Dark Default";
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
            initContent = ''
                  DISABLE_AUTO_TITLE = "true"
              	  if [[ $(uname -m) == 'arm64' ]]; then
              	  	eval "$(/opt/homebrew/bin/brew shellenv)"
              	  fi
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
            pinentry = {
              package = pkgs.pinentry_mac;
            };
            sshKeys = [
              "D3F75A53AAFBFEA33FF8E2F4A5927B868B1C8FBA"
            ];
          };
        };
      };
    };
  nixosModule =
    { ... }:
    {
      home-manager.users.shivangswain = homeModule;
    };
in
(
  (inputs.home-manager.lib.homeManagerConfiguration {
    modules = [
      homeModule
    ];
    pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  })
  // {
    inherit nixosModule;
  }
)
