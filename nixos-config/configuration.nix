# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, haskellLib, fetchgit, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # custom mount points
  fileSystems."/mnt/vault" =
    { device = "/dev/disk/by-label/TheVault";
      fsType = "ntfs";
      options = [ "defaults" ];
    };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries =
    ''
    menuentry "Windows 10" {
      chainloader (hd0,1)+1
    }
    '';

  networking.hostName = "applicative"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat2-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  nixpkgs.config = {
    # needed for xmonad to find xmonadContrib
    # provideOldHaskellAttributeNames = true;
    packageOverrides = pkgs: rec {
      ownHaskellPackages = ver : pkgs.recurseIntoAttrs (ver.override {
        overrides = se : su : rec {
              # needed for xmonad master to configure
              xmonad = se.callPackage ../haskell-projects/xmonad {};
              xmonad-contrib = se.callPackage ../haskell-projects/xmonad-contrib {};
              xmonad-extras = pkgs.haskell.lib.doJailbreak su.xmonad-extras;

              ghc-exactprint = pkgs.haskell.lib.dontCheck su.ghc-exactprint;
            };
          });
      myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc822;
      ghcEnv = myHaskellPackages.ghcWithPackages (p: with p; [
        xmonad xmonad-contrib xmonad-extras xmobar # needed for xmonad
        apply-refact hlint stylish-haskell hasktags hoogle # spacemacs haskell layer
        pretty-show hscolour # .ghci pretty printing support
      ]);
      bluez = pkgs.bluez5.override { enableWiimote = true; };
      linux = pkgs.linuxPackages_latest.kernel;
      linuxPackages = pkgs.linuxPackages_latest;
      project_paintball = pkgs.callPackage ../fonts/project-paintball {};
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    gitAndTools.gitFull
    zlib
    binutils
    gcc
    emacs
    tmux
    htop
    rxvt_unicode
    firefox
    cups
    dmenu
    vimHugeX
    xfontsel
    xlsfonts
    xclip
    bluez5

    ghcEnv
  ];

  # make sure fonts are available!

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      terminus_font
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      dejavu_fonts
      source-code-pro
      project_paintball # splatoon font
   ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # enable nix binary cache access via SSH
  nix.sshServe.enable = true;
  nix.sshServe.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+nty00k0yUsHIzPN86SvBrBYhQnRYVPLTIFkrX4s37d+ho6h/bVqgTfsmNxx1thbBST90j4Kybd37pPWTvUFQfNdl6fesplu2zwlNpB7Tjgu4gl96i+OTOQABgWKGT3ZZyTbA7Sx8OEvLPd37/ugwzIHXgK3lSTgnZcaICP1QnOADtaMAZ/O+f5Gi+hLijMOoYh//h1+TgxH85k24eryQ1KrfiHAyeFuuWuYwCMRM4XqKQ6zw3Q+EYf/hGcS5QjEYb2uyzQ4T8vZR7nyDA8bUH1m2ENNjAYOzG1JmQn6mqzVtHRMlvmU413mj9VqORpNMR6tE7Ifn/59xQQWbfJN7 MP2E@archlinux.us" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.autorun = false;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  services.xserver.windowManager.xmonad.haskellPackages = pkgs.myHaskellPackages;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";
  services.xserver.videoDrivers = [ "nvidia" ];
  services.compton.enable = true;
  services.compton.backend = "glx";
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;

  # virtualisation.virtualbox.host.enable = true;

  nix.useSandbox = true;
  nix.extraOptions = "auto-optimize-store = true";

  programs.zsh.enable = true;
  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  security.sudo.enable = true;
  boot.cleanTmpDir = true;
  time.timeZone = "America/Los_Angeles";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.mwProCapture.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cray = {
    name = "cray";
    extraGroups = [ "wheel" "audio" "networkmanager" ];
    createHome = true;
    home = "/home/cray";
    shell = "/var/run/current-system/sw/bin/zsh";
    uid = 1000;
  };
}

