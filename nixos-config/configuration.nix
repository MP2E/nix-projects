# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # custom mount points
  fileSystems."/mnt/vault" =
    { device = "/dev/disk/by-label/TheVault";
      fsType = "ntfs";
      options = "defaults";
    };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries =
    ''
    menuentry "Windows 7" {
      chainloader (hd0,1)+1
    }
    '';

  networking.hostName = "applicative"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat2-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      ownHaskellPackages = ver : pkgs.recurseIntoAttrs (ver.override {
        extension = se : su : rec {
              xmonad = se.callPackage /home/cray/nix-projects/haskell-projects/xmonad {};
              xmonadContrib = se.callPackage /home/cray/nix-projects/haskell-projects/xmonad-contrib {};
            };
          });
      myHaskellPackages = ownHaskellPackages pkgs.haskellPackages_ghc783;
      bluez = pkgs.bluez5;
    };
    chromium = {
      enablePepperFlash = true;
      jre = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    zsh
    terminus_font
    gitAndTools.gitFull
    zlib
    binutils
    gcc
    emacs
    tmux
    htop
    irssi
    rxvt_unicode
    chromium
    cups
    dmenu
    vim
    xfontsel
    xlsfonts
    xclip
    bluez5
    haskellPackages_ghc783.ghc
    haskellPackages_ghc783.cabalInstall
    haskellPackages_ghc783.cabalBounds
    haskellPackages_ghc783.lens
    haskellPackages_ghc783.lensAeson
    # xmonad and friends are overwritten by my git versions :)
    myHaskellPackages.xmonad
    myHaskellPackages.xmobar
    myHaskellPackages.xmonadContrib
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  services.xserver.displayManager.slim.theme = pkgs.fetchurl {
    url = http://www.mirrorservice.org/sites/downloads.sourceforge.net/s/sl/slim.berlios/slim-mindlock.tar.gz;
    sha256 = "99a6e6acd55bf55ece18a3f644299517b71c1adc49efd87ce2d7e654fb67033c";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  security.sudo.enable = true;
  boot.cleanTmpDir = true;
  time.timeZone = "America/Los_Angeles";

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cray = {
    name = "cray";
    group = "wheel";
    createHome = true;
    home = "/home/cray";
    shell = "/var/run/current-system/sw/bin/zsh";
    uid = 1000;
  };
}

