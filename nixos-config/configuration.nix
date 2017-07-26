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

  services.udev.extraRules = ''
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "comonad"; # Define your hostname.
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
        overrides = se : super : rec {
              # needed for xmonad master to configure
              xmonad = se.callPackage ../haskell-projects/xmonad {};
              xmonad-contrib = se.callPackage ../haskell-projects/xmonad-contrib {};
              xmonad-extras = doJailbreak super.xmonad-extras;


              timezone-series = super.timezone-series_0_1_8;
              hint = super.hint_0_7_0;
              integer-logarithms = dontCheck (doJailbreak super.integer-logarithms_1_0_2);
              libmpd = se.callPackage ../haskell-projects/libmpd {};

              # overrides below copied from:
              # https://gist.github.com/nh2/a6de5e5409c8893d67ef444a7664ed98

              # GHC 8.2 fixes

              # fix upper bounds with doJailbreak
              dynamic-mvector = pkgs.haskell.lib.doJailbreak super.dynamic-mvector;
              threads = pkgs.haskell.lib.doJailbreak super.threads;
              pqueue = pkgs.haskell.lib.doJailbreak super.pqueue;
              quickcheck-instances = pkgs.haskell.lib.doJailbreak super.quickcheck-instances;
              repa = pkgs.haskell.lib.doJailbreak super.repa;
              safecopy = pkgs.haskell.lib.doJailbreak super.safecopy;
              aeson = pkgs.haskell.lib.doJailbreak super.aeson;
              opaleye = pkgs.haskell.lib.doJailbreak super.opaleye;
              servant = pkgs.haskell.lib.doJailbreak super.servant;
              servant-server = pkgs.haskell.lib.doJailbreak super.servant-server;
              servant-client = pkgs.haskell.lib.doJailbreak super.servant-client;
              # fix tests pulling in `rebase` package that's broken with 8.2
              vector-builder = pkgs.haskell.lib.dontCheck super.vector-builder; # https://github.com/nikita-volkov/rebase/issues/9

              # https://github.com/albertoruiz/hmatrix/pull/231
              hmatrix = pkgs.haskell.lib.overrideCabal super.hmatrix (old: {
                src = fetchgit {
                  url = "https://github.com/nh2/hmatrix.git";
                  rev = "8e79121454171b145e5d102e5713299b43604d88";
                  sha256 = "0ksjzvmsdijmvf66dn7pmjy3l2fg4zsbpglvc0bvjvylnhxy521r";
                };
                prePatch = ''
                  cd packages/base
                '';
              });

              # If this doesn't work, disable tests for `yaml`, because then
              # `aeson-qq` doesn't get pulled in, and then `haskell-src-meta` doesn't.
              haskell-src-meta = pkgs.haskell.lib.doJailbreak (pkgs.haskell.lib.overrideCabal super.haskell-src-meta (old: {
                version = "0.8.0.1";
                editedCabalFile = null;
                revision = null;
                sha256 = "1i5f21mx061k50nl3pvvffjqsbvvldl50y8d4b9b31g63l0jg5q9";
                doCheck = false; # Setup: Encountered missing dependencies: HUnit -any, test-framework -any, test-framework-hunit -any
              }));

              # 0.5.1 gives:
              #   test/Windows.hs:60:15: error:
              #       • Exception when trying to run compile-time code:
              #           InvalidAbsDir "C:\\chris\\"
              path = pkgs.haskell.lib.overrideCabal super.path (old: {
                version = "0.6.1";
                sha256 = "0nayla4k1gb821k8y5b9miflv1bi8f0czf9rqr044nrr2dddi2sb";
                doCheck = false; # Setup: Encountered missing dependencies: genvalidity ==0.3.*, genvalidity-property ==0.0.*, validity >=0.3.1.1 && <0.4
              });
              path-io = pkgs.haskell.lib.overrideCabal super.path-io (old: {
                version = "1.3.2";
                sha256 = "031y6dypf6wnwx7fnjyvn2sb5y1lxfibx0jnwc19h93harm3lfyp";
                editedCabalFile = null;
                revision = null;
                doCheck = false; # fails with CCP error "error: missing binary operator before token" (somehow MIN_VERSION_directory isn't defined)
              });

              # https://github.com/fpco/store/pull/110
              store = pkgs.haskell.lib.overrideCabal super.store (old: {
                src = fetchgit {
                  url = "https://github.com/fpco/store.git";
                  rev = "63e56ec4b8eb137bcca217eb0dcd56db129c898a";
                  sha256 = "0mgiwxq749kwcm9m58jh7j6p5vzal3lxs0yga5dfz8cri240jbk4";
                };
                doCheck = false; # https://github.com/fpco/store/issues/111
              });
            };
          });
      myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc821;
      ghcEnv = myHaskellPackages.ghcWithPackages (p: with p; [
        xmonad xmonad-contrib xmonad-extras xmobar # needed for xmonad
#       apply-refact hlint stylish-haskell hasktags hoogle ghc-mod # spacemacs haskell layer
#       pretty-show # .ghci pretty printing support
      ]);
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
    gitAndTools.gitFull
    zlib
    binutils
    gcc
    emacs
    tmux
    htop
    rxvt_unicode
    chromium
    cups
    dmenu
    vim
    xfontsel
    xlsfonts
    xclip
    bluez5
    ntfs3g
    exfat

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.autorun = false;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.xrandrHeads = [
  {output = "eDP1"; primary = true; monitorConfig = ''
     Option "PreferredMode" "1366x768_60.00"
   '';}
  {output = "HDMI1"; monitorConfig = ''
     Option "PreferredMode" "1280x720_60.00"
     Option "RightOf" "eDP1"
   '';}
  ];

  # enable touchpad
  services.xserver.synaptics.enable = true;

  # important for work!
  services.teamviewer.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  services.xserver.windowManager.xmonad.haskellPackages = pkgs.myHaskellPackages;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.default = "xmonad";
  services.xserver.desktopManager.default = "none";
  services.xserver.videoDrivers = [ "intel" ];
  services.compton.enable = true;
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

