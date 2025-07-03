{ inputs, ... }@flakeContext:
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
            pkgs.ffmpeg
            pkgs.nixfmt-rfc-style
            pkgs.fzf
            pkgs.git
            pkgs.gnupg
            pkgs.home-manager
            pkgs.htop
            pkgs.mkalias
            pkgs.neovim
            pkgs.nodejs
            pkgs.oh-my-posh
            pkgs.python3
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
            pkgs.inter
            pkgs.lexend
            pkgs.nerd-fonts.code-new-roman
            pkgs.source-sans
          ];
        };
        homebrew = {
          brews = [
            "mas"
          ];
          casks = [
            "adobe-digital-editions"
            "aldente"
            "brave-browser"
            "calibre"
            "citrix-workspace"
            "discord"
            "idrive"
            "iina"
            "microsoft-excel"
            "microsoft-powerpoint"
            "microsoft-word"
            "nvidia-geforce-now"
            "obsidian"
            "onyx"
            "qbittorrent"
            "rectangle"
            "shottr"
            "visual-studio-code"
          ];
          enable = true;
          masApps = {
            Bitwarden = 1352778147;
            "Hand Mirror" = 1502839586;
            "Hidden Bar" = 1452453066;
            NordVPN = 905953485;
            WhatsApp = 310633997;
            "Windows App" = 1295203466;
            "Wipr 2" = 1662217862;
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
            services = {
              sudo_local = {
                touchIdAuth = true;
              };
            };
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
                "/System/Applications/Utilities/Terminal.app"
                "/Applications/WhatsApp.app"
                "/System/Applications/iPhone\ Mirroring.app"
              ];
              persistent-others = [
                "/Users/shivangswain/Downloads"
              ];
              show-recents = false;
            };
          };
          primaryUser = "shivangswain";
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
