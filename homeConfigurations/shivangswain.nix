# User-level configuration using home-manager
# Can be used standalone: home-manager switch --flake ~/.config/nix#shivangswain
# Or integrated with nix-darwin via the nixosModule export
{ inputs, ... }@flakeContext:
let
  # Home-manager module defining user configuration
  homeModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        # Basic home-manager settings
        home = {
          homeDirectory = "/Users/shivangswain";
          stateVersion = "25.05"; # Do not change after initial setup
          username = "shivangswain";
        };

        programs = {
          # Git configuration with GPG signing
          git = {
            enable = true;
            settings = {
              user = {
                email = "me@shivangswain.com";
                name = "shivangswain";
              };
            };
            signing = {
              key = "826FF286FEC7417A";
              signByDefault = true;
            };
          };

          # GPG for encryption and signing
          gpg.enable = true;

          # Neovim as default editor
          neovim = {
            enable = true;
            defaultEditor = true;
            extraLuaConfig = ''
              -- Use 2 spaces for indentation
              vim.opt.softtabstop = 2
              vim.opt.expandtab = true
            '';
          };

          # Python package manager
          uv.enable = true;

          # VS Code configuration (managed declaratively)
          vscode = {
            enable = true;
            profiles.default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;

              extensions = with pkgs.vscode-extensions; [
                # Web development
                astro-build.astro-vscode
                bradlc.vscode-tailwindcss
                esbenp.prettier-vscode
                wix.vscode-import-cost

                # Git integration
                eamodio.gitlens

                # AI assistance
                github.copilot
                github.copilot-chat

                # Theme
                github.github-vscode-theme

                # Markdown
                bierner.github-markdown-preview

                # Nix support
                jnoortheen.nix-ide

                # Python development
                ms-python.debugpy
                ms-python.isort
                ms-python.python

                # Data formats
                redhat.vscode-xml
                redhat.vscode-yaml

                # Vim keybindings
                vscodevim.vim
              ];

              userSettings = {
                # Nix formatting
                "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";

                # Python import organization
                "[python]"."editor.codeActionsOnSave"."source.organizeImports" = "explicit";

                # AI features
                "chat.agent.enabled" = true;

                # Editor behavior
                "editor.cursorSmoothCaretAnimation" = "on";
                "editor.defaultFormatter" = "esbenp.prettier-vscode";
                "editor.formatOnSave" = true;
                "editor.tabSize" = 2;
                "editor.wordWrap" = "on";

                # Git settings
                "git.autofetch" = true;
                "git.confirmSync" = false;
                "git.enableCommitSigning" = true;

                # Disable VS Code auto-updates (managed by Nix)
                "update.mode" = "none";

                # UI customization
                "workbench.activityBar.location" = "hidden";
                "workbench.colorTheme" = "GitHub Dark Default";
              };
            };
          };

          # Zsh shell configuration
          zsh = {
            enable = true;
            enableCompletion = true;

            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            # Shell initialization script
            initContent = ''
              # Initialize Homebrew on Apple Silicon
              if [[ $(uname -m) == 'arm64' ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
              fi

              # Disable automatic terminal title updates
              DISABLE_AUTO_TITLE='true'

              # Minimal prompt: '>' or red '>' on error, '#' for root
              PROMPT='%(?.%(!.#.>).%F{9}%(!.#.>)%f) '

              # Right prompt: directory and time
              RPROMPT='%F{8}%2~/%f %D{%L:%M %p}'
              ZLE_RPROMPT_INDENT=0
            '';

            # Oh My Zsh framework
            oh-my-zsh = {
              enable = true;
              plugins = [
                "cp" # Progress bar for cp
                "fzf" # Fuzzy finder integration
                "zoxide" # Smart directory navigation
              ];
            };
          };
        };

        # Background services
        services = {
          # GPG agent for key management and SSH authentication
          gpg-agent = {
            enable = true;
            enableSshSupport = true;
            enableZshIntegration = true;
            pinentry.package = pkgs.pinentry_mac;
            # SSH key keygrips to expose via GPG agent
            sshKeys = [
              "D3F75A53AAFBFEA33FF8E2F4A5927B868B1C8FBA"
            ];
          };
        };
      };
    };

  # Module wrapper for integration with nix-darwin
  nixosModule =
    { ... }:
    {
      home-manager.users.shivangswain = homeModule;
    };
in
# Export both standalone configuration and nix-darwin integration module
(inputs.home-manager.lib.homeManagerConfiguration {
  modules = [ homeModule ];
  pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
})
// {
  inherit nixosModule;
}
