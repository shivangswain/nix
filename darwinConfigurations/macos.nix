# macOS system configuration using nix-darwin
# Apply with: darwin-rebuild switch --flake ~/.config/nix#macos
{ inputs, ... }:
let
  darwinModule =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        # Enable home-manager as a nix-darwin module
        inputs.home-manager.darwinModules.home-manager
        # Import user's home-manager configuration
        inputs.self.homeConfigurations.shivangswain.nixosModule
        {
          # Use the system-level nixpkgs instance for home-manager
          home-manager.useGlobalPkgs = true;
          # Install packages to /etc/profiles instead of ~/.nix-profile
          home-manager.useUserPackages = true;
        }
      ];

      config = {
        # Disable documentation generation to speed up builds
        documentation.enable = false;

        # System-wide packages available to all users
        environment.systemPackages = with pkgs; [
          android-tools # ADB and fastboot
          aria2 # Download utility
          bat # Cat clone with syntax highlighting
          black # Python code formatter
          bootdev-cli # CLI to complete Boot.dev coding challenges & lessons
          btop # Resource monitor
          bun # Fast JavaScript runtime and package manager
          cargo # Rust package manager
          delta # Diff viewer
          eza # ls clone with extra features
          fd # Fast find alternative
          ffmpeg # Media processing
          fzf # Fuzzy finder
          git # Version control
          gnupg # GPG encryption
          home-manager # User environment manager
          htop # Process viewer
          lazygit # Terminal UI for git
          mkalias # Create macOS aliases from Nix store
          neovim # Text editor
          nixd # Nix language server
          nixfmt # Nix formatter
          nodejs-slim # Node.js runtime
          oh-my-zsh # Zsh configuration framework
          pi-coding-agent # Coding agent CLI
          python3 # Python interpreter
          rclone # Cloud storage sync
          ripgrep # Fast recursive grep
          rsync # File synchronization
          rustc # Rust compiler
          rustfmt # Rust formatter
          tmux # Terminal multiplexer
          uv # Fast Python package manager
          zoxide # Smart cd command
          zsh # Z shell
          zsh-autocomplete # Real-time autocompletion
          zsh-autosuggestions # Fish-like suggestions
          zsh-syntax-highlighting # Syntax highlighting
        ];

        # Fonts installed system-wide
        fonts.packages = with pkgs; [
          font-awesome
          inter
          nerd-fonts.code-new-roman
        ];

        # Homebrew configuration for packages not in nixpkgs
        homebrew = {
          enable = true;

          # GUI applications installed via Homebrew Cask
          casks = [
            "brave-browser"
            "calibre"
            "citrix-workspace"
            "discord"
            "ghostty"
            "iina"
            "nvidia-geforce-now"
            # "onyx"
            "qbittorrent"
            "signal"
            "visual-studio-code"
            "vorssaint"
          ];

          # Always upgrade casks, even those with built-in auto update mechanisms
          greedyCasks = true;

          # Mac App Store applications (requires mas CLI)
          masApps = {
            "Bitwarden" = 1352778147;
            "Hidden Bar" = 1452453066;
            "NordVPN" = 905953485;
            "Remote Mouse" = 403195710;
            "SponsorBlock" = 1573461917;
            "uBlock Origin Lite" = 6745342698;
            "WhatsApp" = 310633997;
            "Windows App" = 1295203466;
          };

          onActivation = {
            autoUpdate = true; # Update Homebrew itself
            cleanup = "zap"; # Remove old versions of packages
            extraEnv = {
              "HOMEBREW_NO_ANALYTICS" = "1"; # Disable Homebrew analytics
            };
            upgrade = true; # Upgrade outdated packages
          };
        };

        # Nix daemon configuration
        nix.settings = {
          # Enable flakes and new nix command
          experimental-features = "nix-command flakes";
        };

        # Allow installation of unfree packages (e.g., proprietary software)
        nixpkgs.config.allowUnfree = true;

        # Enable zsh as a system shell
        programs.zsh.enable = true;

        security.pam.services.sudo_local = {
          # Enable Touch ID for sudo authentication
          touchIdAuth = true;
        };

        # macOS system preferences
        system = {
          defaults = {
            # Control Center visibility settings
            controlcenter = {
              AirDrop = false;
              BatteryShowPercentage = false;
              Bluetooth = false;
              Display = false;
              FocusModes = false;
              NowPlaying = false;
              Sound = false;
            };

            CustomSystemPreferences = {
              "/Library/Preferences/com.brave.Browser.plist" = {
                "BraveAIChatEnabled" = false;
                "BraveAIEnabled" = false;
                "BraveChatEnabled" = false;
                "BraveLeoEnabled" = false;
                "BraveNewsDisabled" = true;
                "BraveRewardsDisabled" = true;
                "BraveStatsPingEnabled" = false;
                "BraveTalkDisabled" = true;
                "BraveVPNDisabled" = true;
                "BraveWalletDisabled" = true;
                "CryptoWalletEnabled" = false;
                "TorDisabled" = true;
              };
            };

            dock = {
              autohide = true;
              largesize = 80;
              magnification = true;
              orientation = "left";
              persistent-apps = [
                "/System/Cryptexes/App/System/Applications/Safari.app"
                "/System/Applications/Mail.app"
                "/System/Applications/Music.app"
                "/Applications/Ghostty.app"
                "/Applications/Visual Studio Code.app"
                "/Applications/WhatsApp.app"
              ];
              persistent-others = [
                "/Users/shivangswain/Downloads"
              ];
              show-recents = false;
            };

            finder = {
              FXRemoveOldTrashItems = true; # Auto-remove items after 30 days
              NewWindowTarget = "Home";
              ShowPathbar = true;
            };

            # Menu bar clock settings
            menuExtraClock = {
              FlashDateSeparators = false;
              ShowDate = 1;
              ShowDayOfWeek = true;
            };

            # Global system preferences
            NSGlobalDomain = {
              AppleInterfaceStyle = "Dark";
            };

            # Software Update settings
            SoftwareUpdate = {
              AutomaticallyInstallMacOSUpdates = true;
            };
          };

          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };

          # Primary user for system operations
          primaryUser = "shivangswain";

          # nix-darwin state version (do not change after initial setup)
          stateVersion = 6;
        };

        users.users.shivangswain = {
          home = "/Users/shivangswain";
          name = "shivangswain";
        };
      };
    };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [ darwinModule ];
  system = "aarch64-darwin"; # Apple Silicon
}
