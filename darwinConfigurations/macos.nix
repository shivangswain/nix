{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.shivangswain.nixosModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
    config = {
      documentation = {
        enable = false;
      };
      environment = {
        systemPackages = [
          pkgs.aria2
          pkgs.fd
          pkgs.fzf
          pkgs.git
          pkgs.gnupg
          pkgs.home-manager
          pkgs.htop
          pkgs.mas
          pkgs.mkalias
          pkgs.neovim
          pkgs.nodejs_22
          pkgs.oh-my-posh
          pkgs.zoxide
          pkgs.zsh
          pkgs.zsh-autocomplete
          pkgs.zsh-autosuggestions
          pkgs.zsh-syntax-highlighting
        ];
      };
      fonts = {
        packages = [
          pkgs.font-awesome
        ];
      };
      homebrew = {
        casks = [
          "aldente"
          "brave-browser"
          "citrix-workspace"
          "discord"
          "ghostty"
          "idrive"
          "iina"
          "microsoft-excel"
          "microsoft-powerpoint"
          "microsoft-word"
          "nvidia-geforce-now"
          "qbittorrent"
          "shottr"
          "visual-studio-code"
        ];
        enable = true;
        global = {
          autoUpdate = false;
        };
        masApps = {
          Bitwarden = 1352778147;
          CopyClip = 595191960;
          "Hand Mirror" = 1502839586;
          "Hidden Bar" = 1452453066;
          NordVPN = 905953485;
          WhatsApp = 310633997;
        };
        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
          upgrade = true;
        };
      };
      nix = {
        settings = {
          experimental-features = "nix-command flakes";
        };
      };
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
      programs = {
        zsh = {
          enable = true;
        };
      };
      security = {
        pam = {
          enableSudoTouchIdAuth = true;
        };
      };
      services = {
        nix-daemon = {
          enable = true;
        };
      };
      system = {
        defaults = {
          controlcenter = {
            AirDrop = false;
            BatteryShowPercentage = false;
            Bluetooth = false;
            Display = false;
            FocusModes = false;
            NowPlaying = false;
            Sound = false;
          };
          dock = {
            autohide = true;
            largesize = 80;
            magnification = true;
            orientation = "left";
            persistent-apps = [
              "/System/Cryptexes/App/System/Applications/Safari.app"
              "/System/Applications/Messages.app"
              "/System/Applications/Mail.app"
              "/System/Applications/Music.app"
              "/Applications/Ghostty.app"
              "/Applications/WhatsApp.app"
              "/System/Applications/iPhone\ Mirroring.app"
            ];
            persistent-others = [
              "/Users/shivangswain/Downloads"
              "/Users/shivangswain/Library/Mobile Documents/com\~apple\~CloudDocs/Downloads"
            ];
            show-recents = false;
          };
        };
        stateVersion = 5;
      };
      users = {
        users = {
          shivangswain = {
            home = /Users/shivangswain;
            name = "shivangswain";
          };
        };
      };
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
  ];
  system = "aarch64-darwin";
}
