{ config, pkgs, ... }: {

  imports = (builtins.filter builtins.pathExists [
    ./hardware-configuration.nix
    ./local.nix
    ./users.nix
  ]);

  boot = {
    cleanTmpDir = true;

    loader.grub = {
      device = "/dev/sda";
      enable = true;
      version = 2;
    };
  };

  environment.etc = {
    "modprobe.d/hid_apple.conf".text =
      ''
        options hid_apple fnmode=2
        options hid_apple swap_opt_cmd=1
      '';
  };

  environment.systemPackages = with pkgs; [
    ctags
    diffutils
    dmenu
    emacs
    file
    git
    git-lfs
    gnupg
    gnutls
    hunspell
    jq
    lld
    nix-index
    nix-prefetch-git
    nix-repl
    nixpkgs-lint
    openssl
    ripgrep
    sdcv
    termite
    tree
    upx
    vim
    wordnet
    zsh
  ] ++ (with haskellPackages; [
    ShellCheck
    apply-refact
    bench
    cabal2nix
    codex
    hasktags
    hlint
    hpack
    hspec-discover
    steeloverseer
    threadscope
  ]);

  environment.variables = {
    NO_AT_BRIDGE = "1";
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "inconsolata" ];
      };
    };
    fonts = with pkgs; [
      corefonts
      hasklig
      inconsolata
      source-code-pro
      symbola
      ubuntu_font_family
    ];
  };

  hardware = {
    opengl.driSupport32Bit  = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  i18n = {
    consoleKeyMap = "dvorak";
  };

  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableAdobeFlash = true;
      enableAdobeFlashDRM = true;
      enableDjvu = true;
      enableGoogleTalkPlugin = true;
      icedtea = true;
    };
    pulseaudio = true;
  };

  programs = {
    bash = {
      enableCompletion = true;
    };
    ssh.startAgent = true;

    tmux.enable =  true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  services = {
    ntp.enable = true;
    openssh.enable = false;
    printing.enable = true;
    tlp.enable = true;

    xserver = {
      autorun = true;
      enable = true;
      layout = "us,us";
      xkbVariant = "dvorak,";
      xkbOptions = "caps:ctrl_modifier,ctrl:ralt_rctrl,grp:shifts_toggle";

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };
      displayManager = {
        sessionCommands = ''
          xset r rate 300 50
        '';
        slim = {
          autoLogin = false;
          enable = true;
        };
      };
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };

  system = {
    # autoUpgrade.enable = true;
    stateVersion = "17.09";
  };

  time.timeZone = "US/Pacific";

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    storageDriver = "devicemapper";
  };

}
