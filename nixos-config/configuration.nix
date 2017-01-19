# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with import ../../nixpkgs/pkgs/development/haskell-modules/lib.nix { inherit pkgs; };

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
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" GROUP="wheel"
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
              X11 = su.X11_1_7;
              xmonad = se.callPackage ../haskell-projects/xmonad {};
              xmonad-contrib = se.callPackage ../haskell-projects/xmonad-contrib {};
            };
          });
      myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc802;
      bluez = pkgs.bluez5.override { enableWiimote = true; };
      linux = pkgs.linuxPackages_latest.kernel;
      linuxPackages = pkgs.linuxPackages_latest;
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
  ];

  # make sure fonts are available!

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      terminus_font
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
   ];
  };

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

  # virtualisation.virtualbox.host.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  security.sudo.enable = true;
  boot.cleanTmpDir = true;
  time.timeZone = "America/Los_Angeles";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
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

