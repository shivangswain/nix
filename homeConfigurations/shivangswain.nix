# User-level configuration using home-manager
# Can be used standalone: home-manager switch --flake ~/.config/nix#shivangswain
# Or integrated with nix-darwin via the nixosModule export
{ inputs, ... }:
let
  # Home-manager module defining user configuration
  homeModule =
    {
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
          ghostty = {
            enable = true;
            enableZshIntegration = true;
            package = null;

            settings = {
              # Auto-switch theme with macOS appearance
              theme = "light:GitHub,dark:GitHub Dark";

              # Font settings
              font-family = "CodeNewRoman Nerd Font";
              font-size = 14;

              # Window chrome
              background-blur = "macos-glass-regular";
              background-opacity = 0.90;
              macos-option-as-alt = true;
              macos-titlebar-style = "tabs";
              window-padding-balance = true;
              window-padding-x = 12;
              window-padding-y = "6,12";
              window-save-state = "always";

              # Cursor: blinking line
              cursor-style = "bar";
              cursor-style-blink = true;

              # Behaviour
              clipboard-trim-trailing-spaces = true;
              confirm-close-surface = false;
              copy-on-select = "clipboard";
              mouse-hide-while-typing = true;
              scrollback-limit = 10485760; # 10 MiB
              shell-integration = "zsh";
              shell-integration-features = [
                "cursor"
                "sudo"
                "title"
                "ssh-env"
                "ssh-terminfo"
              ];
            };
          };

          # Git configuration with GPG signing
          git = {
            enable = true;
            settings = {
              init.defaultBranch = "master";
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

          gpg.enable = true;

          neovim = {
            defaultEditor = true;
            enable = true;
            initLua = ''
              -- Use 2 spaces for indentation
              vim.opt.softtabstop = 2
              vim.opt.expandtab = true
            '';
          };

          npm.enable = true;

          pi-coding-agent = {
            enable = true;
            package = null;
            settings = {
              defaultProvider = "tokenrouter";
              enableInstallTelemetry = false;
              packages = [
                "npm:@realvendex/pi-token-router"
              ];
              theme = "dark";
            };
          };

          tmux = {
            aggressiveResize = true; # Resize windows to the smallest client actually viewing them
            baseIndex = 1; # Windows/panes start at 1 (matches keyboard row order)
            enable = true;
            escapeTime = 0; # No delay after pressing Escape (matters for Vim/Neovim)
            historyLimit = 50000; # Larger scroll back buffer
            keyMode = "vi"; # Vi-style key bindings in copy mode
            mouse = true; # Mouse support for pane/window selection and scrolling
            prefix = "C-a"; # C-a is easier to reach than the default C-b
            terminal = "tmux-256color"; # 256-colour terminal with true-colour pass through
          };

          # Python package manager
          uv.enable = true;

          vscode = {
            enable = true;
            package = null;

            # Immutable extension directory managed by Nix
            mutableExtensionsDir = false;

            profiles.default = {
              # Disable update/extension checks
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;

              # Extensions
              extensions = (
                with pkgs.vscode-extensions;
                [
                  bierner.markdown-checkbox # Markdown checkbox support
                  bierner.markdown-emoji # Markdown emoji support
                  bierner.markdown-footnotes # Markdown footnote support
                  bierner.markdown-mermaid # Markdown mermaid diagram support
                  bierner.markdown-preview-github-styles # Markdown preview with GitHub styles
                  bradlc.vscode-tailwindcss
                  elijah-potter.harper # grammar checker
                  esbenp.prettier-vscode # prettier code formatter
                  github.github-vscode-theme
                  jnoortheen.nix-ide # nix language support
                  ms-python.black-formatter # black code formatter for Python
                  ms-python.isort # import sorting for Python
                  ms-python.python
                  ms-python.vscode-pylance # Python language server
                  redhat.vscode-xml # XML language support
                ]
              );

              userSettings = {
                # Theme (GitHub Dark / Light, auto-switch)
                "window.autoDetectColorScheme" = true;
                "workbench.preferredDarkColorTheme" = "GitHub Dark Default";
                "workbench.preferredLightColorTheme" = "GitHub Light Default";

                # Editor behaviour
                "editor.cursorBlinking" = "smooth";
                "editor.cursorSmoothCaretAnimation" = "on";
                "editor.defaultFormatter" = "esbenp.prettier-vscode";
                "editor.fontFamily" = "CodeNewRoman Nerd Font, Menlo, Monaco, 'Courier New', monospace";
                "editor.fontSize" = 14;
                "editor.formatOnSave" = true;
                "editor.insertSpaces" = false; # hard tabs
                "editor.smoothScrolling" = true;
                "editor.tabSize" = 2;
                "workbench.list.smoothScrolling" = true;

                # Terminal settings
                "terminal.external.osxExec" = "Ghostty.app";
                "terminal.integrated.cursorBlinking" = true;
                "terminal.integrated.cursorStyle" = "line";
                "terminal.integrated.cursorStyleInactive" = "line";
                "terminal.integrated.smoothScrolling" = true;

                # Language-specific formatters
                "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
                "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
                "[xml]"."editor.defaultFormatter" = "redhat.vscode-xml";

                # Nix language
                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nixd";
                "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];

                # Python language
                "python.analysis.typeCheckingMode" = "standard";
                "isort.args" = [
                  "--profile"
                  "black"
                ];

                # Telemetry (all off)
                "telemetry.feedback.enabled" = false;
                "telemetry.telemetryLevel" = "off";
                "workbench.enableExperiments" = false;

                # Harper (grammar checker)
                "harper.dialect" = "British";
              };
            };
          };

          zsh = {
            enable = true;
            enableCompletion = true;

            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

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

              # Add ~/.local/bin to path (used by Claude Code native install)
              export PATH="$HOME/.local/bin:$PATH"
            '';

            oh-my-zsh = {
              enable = true;
              plugins = [
                "cp" # Progress bar for cp
                "eza" # ls replacement with extra features
                "fzf" # Fuzzy finder integration
                "macos" # macOS-specific integrations
                "tmux" # tmux integration
                "zoxide" # Smart directory navigation
              ];
            };
          };
        };

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
