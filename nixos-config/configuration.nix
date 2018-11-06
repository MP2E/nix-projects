# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, haskellLib, fetchgit, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  services.udev.extraRules = ''
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # help GHC team find xmobar crash cause by enabling core dumps
  systemd.coredump.enable = true;
  security.pam.loginLimits =
    [ { domain = "*";
        type   = "soft";
        item   = "core";
        value  = "500";
      }
    ];

  networking.hostName = "comonad"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

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
              xmonad         = se.callPackage ../haskell-projects/xmonad {};
              xmonad-contrib = se.callPackage ../haskell-projects/xmonad-contrib {};
            };
          });
      myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc862;
      ghcEnv = myHaskellPackages.ghcWithPackages (p: with p; [
        xmonad xmonad-contrib xmobar # needed for xmonad
#       apply-refact hlint stylish-haskell hasktags hoogle # spacemacs haskell layer
        pretty-show hscolour # .ghci pretty printing support
      ]);
      bluez = pkgs.bluez5.override { enableWiimote = true; };
      linux = pkgs.linuxPackages_latest.kernel;
      linuxPackages = pkgs.linuxPackages_latest;
    };
#   virtualbox.enableExtensionPack = true;
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
    xclip
    bluez5
    ntfs3g
    exfat
    dunst

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
   ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  programs.ssh.startAgent = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.autorun = false;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.xrandrHeads = [
  {output = "eDP-1"; primary = true; monitorConfig = ''
     Option "PreferredMode" "1366x768_60.00"
   '';}
  {output = "HDMI-1"; monitorConfig = ''
     Option "PreferredMode" "1280x720_60.00"
     Option "RightOf" "eDP-1"
   '';}
  ];

  # enable touchpad
  services.xserver.synaptics.enable = true;

  # important for work!
  # services.teamviewer.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  services.xserver.windowManager.xmonad.haskellPackages = pkgs.myHaskellPackages;
  services.xserver.windowManager.xmonad.enable = true;
# services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";
  services.xserver.videoDrivers = [ "modesetting" ];
  services.compton.enable = true;
  services.compton.backend = "glx";
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql80;
  services.mysql.dataDir = "/var/lib/mysql";
  services.mysql.extraOptions = ''
    lower_case_table_names = 1
    default-time-zone='America/Los_Angeles'
  '';

# virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;

  nix.useSandbox = true;

  programs.zsh.enable = true;

  security.sudo.enable = true;
  boot.cleanTmpDir = true;
  time.timeZone = "America/Los_Angeles";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;

# services.mpd.enable = true;

  system.stateVersion = "19.03";
  documentation.nixos.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cray = {
    name = "cray";
    extraGroups = [ "wheel" "audio" "networkmanager" "vboxusers" "libvirtd" ];
    createHome = true;
    home = "/home/cray";
    shell = "/var/run/current-system/sw/bin/zsh";
    uid = 1000;
  };
}

