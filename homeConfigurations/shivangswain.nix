# User-level configuration using home-manager
# Can be used standalone: home-manager switch --flake ~/.config/nix#shivangswain
# Or integrated with nix-darwin via the nixosModule export
{ inputs, ... }:
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
          stateVersion = "26.05"; # Do not change after initial setup
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
            initLua = ''
              -- Use 2 spaces for indentation
              vim.opt.softtabstop = 2
              vim.opt.expandtab = true
            '';
          };

          # Node package manager
          npm.enable = true;

          # Python package manager
          uv.enable = true;

          # VSCode
          vscode = {
            enable = true;

            # Nix-managed extensions (immutable, mirrors old Zed approach)
            # mutableExtensionsDir = false;

            profiles.default = {
              # Disable update/extension checks (Nix handles this)
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;

              # Extensions (VSCode marketplace equivalents of Zed extensions)
              extensions = with pkgs.vscode-extensions; [
                anthropic.claude-code # claude-code
                bradlc.vscode-tailwindcss # tailwindcss
                # elijah-potter.harper # harper (grammar checker)
                esbenp.prettier-vscode # prettier code formatter
                github.github-vscode-theme # github-theme
                jnoortheen.nix-ide # nix language support
                ms-python.python # python
              ];

              userSettings = {
                # ── Theme (GitHub Dark / Light, auto-switch) ──
                "window.autoDetectColorScheme" = true;
                "workbench.preferredDarkColorTheme" = "GitHub Dark Default";
                "workbench.preferredLightColorTheme" = "GitHub Light Default";

                # ── Editor behavior ──
                "editor.formatOnSave" = true;
                "editor.tabSize" = 2;
                "editor.insertSpaces" = false; # hard tabs

                # ── Nix language (nil server via nix-ide) ──
                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nixd";
                "nix.serverSettings".nil.formatting.command = [ "nixfmt" ];

                # ── Telemetry (all off) ──
                "telemetry.telemetryLevel" = "off";
                "workbench.enableExperiments" = false;

                # -- Harper (grammar checker) --
                "harper.dialect" = "British";
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

              # Initialize NPM global directory to path
              export PATH="$HOME/.npm/bin:$PATH"
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
