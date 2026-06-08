# macOS system configuration using nix-darwin
# Apply with: darwin-rebuild switch --flake ~/.config/nix#macos
{ inputs, ... }:
let
  darwinModule =
    {
      config,
      lib,
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
          cargo # Rust package manager
          claude-code # Claude code
          fd # Fast find alternative
          ffmpeg # Media processing
          fzf # Fuzzy finder
          git # Version control
          gnupg # GPG encryption
          home-manager # User environment manager
          htop # Process viewer
          mkalias # Create macOS aliases from Nix store
          neovim # Text editor
          nixd # Nix language server
          nixfmt # Nix formatter
          nodejs_24 # Node.js runtime
          oh-my-posh # Prompt theme engine
          rustc # Rust compiler
          typescript # TypeScript compiler
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
          nerd-fonts.lilex
        ];

        # Homebrew configuration for packages not in nixpkgs
        homebrew = {
          enable = true;

          # CLI tools installed via Homebrew
          brews = [
            "mas" # Mac App Store CLI
          ];

          # GUI applications installed via Homebrew Cask
          casks = [
            "adobe-digital-editions"
            "antigravity"
            "calibre"
            "citrix-workspace"
            "claude"
            "discord"
            "helium-browser"
            "iina"
            "nvidia-geforce-now"
            "obsidian"
            "onyx"
            "qbittorrent"
            "sanesidebuttons"
            "scroll-reverser"
            "shottr"
            "utm"
            "visual-studio-code"
            "zen"
            "zoom"
          ];

          # Always upgrade casks, even those with built-in auto-update mechanisms
          greedyCasks = true;

          # Mac App Store applications (requires mas CLI)
          masApps = {
            "Bitwarden" = 1352778147;
            "Hand Mirror" = 1502839586;
            "Hidden Bar" = 1452453066;
            "NordVPN" = 905953485;
            "SponsorBlock" = 1573461917;
            "uBlock Origin Lite" = 6745342698;
            "WhatsApp" = 310633997;
            "Windows App" = 1295203466;
          };

          # Homebrew behavior on system activation
          onActivation = {
            autoUpdate = true; # Update Homebrew itself
            cleanup = "zap"; # Remove all unmanaged casks/brews
            extraEnv = {
              "HOMEBREW_NO_ANALYTICS" = "1"; # Disable Homebrew analytics
            };
            extraFlags = [
              "--force-cleanup" # Skip the interactive confirmation brew bundle now requires for cleanup
            ];
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

        # Security settings
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

            # Dock configuration
            dock = {
              autohide = true;
              largesize = 80;
              magnification = true;
              orientation = "left";
              persistent-apps = [
                "/System/Cryptexes/App/System/Applications/Safari.app"
                "/System/Applications/Mail.app"
                "/System/Applications/Music.app"
                "/System/Applications/Utilities/Terminal.app"
                "/Applications/Visual Studio Code.app"
                "/Applications/WhatsApp.app"
                "/Applications/Claude.app"
              ];
              persistent-others = [
                "/Users/shivangswain/Downloads"
              ];
              show-recents = false;
            };

            # Finder preferences
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
              AppleInterfaceStyle = "Dark"; # Dark mode
            };

            # Software Update settings
            SoftwareUpdate = {
              AutomaticallyInstallMacOSUpdates = true;
            };
          };

          # Keyboard remapping
          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };

          # Primary user for system operations
          primaryUser = "shivangswain";

          # nix-darwin state version (do not change after initial setup)
          stateVersion = 6;
        };

        # User account configuration
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
