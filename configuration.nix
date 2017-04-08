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

  environment.systemPackages =
    let
      nu = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};
    in
      (with pkgs; [
        clang
        cppcheck
        csslint
        ctags
        dmenu
        emacs
        git
        gnupg
        gnutls
        graphviz
        hunspell
        hunspellDicts.en-us
        jq
        keychain
        mkpasswd
        nix-repl
        nixops
        nixpkgs-lint
        openssl
        pinentry
        python35Packages.pylint
        ruby
        silver-searcher
        termite
        tmux
        vim
        z3
        zsh
      ]) ++ (with nu.pkgs; [
        brotli
        docker
        firefox
        nodejs
        torbrowser
      ]) ++ (with nu.haskellPackages; [
        ShellCheck
        apply-refact
        bench
        cabal-install
        cabal2nix
        codex
        ghc
        hasktags
        hindent
        hlint
        hoogle
        hpack
        hpc_0_6_0_3
        hspec-discover
        pandoc
        shake
        stack
        threadscope
        xmobar
      ]);

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
      inconsolata
      source-code-pro
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
    ssh.startAgent = false;
  };

  services = {
    ntp.enable = true;
    openssh.enable = false;
    printing.enable = true;

    xserver = {
      autorun = true;
      enable = true;
      layout = "us";

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
    stateVersion = "17.03";
  };

  time.timeZone = "US/Pacific";

  virtualisation.docker = {
    enable = true;
    storageDriver = "devicemapper";
  };

}
