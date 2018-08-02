{ pkgs }:

with pkgs;
let
  # Directories where I'll store extra packages.
  normalProjectDir = "/home/cray/nix-projects/";
  haskellProjectDir = normalProjectDir + "haskell-projects/";

  # Wrap callPackage with the default Haskell directories.
  haskellPackage = s: p: s.callPackage (haskellProjectDir + p) {};
  haskellPackageS = s: p: s.callPackage (haskellProjectDir + p);
  haskellPackageC = s: p: v: s.callPackage (haskellProjectDir + p) v;

  # Wrap callPackage with the default non-Haskell directories.
  normalPackage = p: callPackage (normalProjectDir + p) {};
  normalPackage32 = p: callPackage_i686 (normalProjectDir + p) {};
  normalPackageS = s: p: s.callPackage (normalProjectDir + p) {};
  normalPackageO = p: v: callPackage (normalProjectDir + p) v;
  normalPackageC = s: p: v: s.callPackage (normalProjectDir + p) v;

  # Custom dev package function
  devPackage = p: callPackage (normalProjectDir + p + "/master.nix") {};
  devPackageC = s: p: v: s.callPackage (normalProjectDir + p + "/master.nix") v;

in
{ allowUnfree = true;
  packageOverrides = self: rec {
    # Haskell packages I want to use that reside out of nixpkgs or don't
    # have the settings I want.
    ownHaskellPackages = ver : recurseIntoAttrs (ver.override {
      overrides = se : su : rec {
        # needed for xmonad master
        xmonad           = haskellPackage se "xmonad";
        xmonad-contrib   = haskellPackage se "xmonad-contrib";
        xmonad-extras    = haskellPackage se "xmonad-extras";

        vty              = haskellPackage se "vty";
        irc-core         = haskellPackage se "irc-core";
        glirc            = haskellPackage se "glirc";

        ghc-exactprint   = pkgs.haskell.lib.dontCheck su.ghc-exactprint;
      };
    });

    # Derive package sets for the versions of GHC I'm interested in.
    myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc843;

    haskellEnv = myHaskellPackages.ghcWithPackages (p: with p; [
      attoparsec parsec aeson mtl transformers lens lens-aeson
      text random vector stm comonad free total network HTTP
      QuickCheck deepseq deepseq-generics hspec optparse-applicative
      bytestring pipes turtle foldl cereal OpenGL GLUT
      hlint cabal-install hoogle yesod yesod-bin djinn alex happy
      intero stack
      xmonad xmonad-contrib xmobar
      corrode
    ]);

#   jsEnv = haskell.packages.ghcjs.ghcWithPackages (p: with p; [
#     reflex reflex-dom ghcjs-dom
#   ]);

    # Packages that aren't Haskell packages.
    sixpair      = normalPackage "sixpair";
    doom64ex     = normalPackage "doom64ex";
    wadgen       = normalPackage "wadgen";
    slade        = normalPackageO "slade" { wxGTK30 = pkgs.wxGTK30.override { withWebKit = true; }; };
    zdbsp        = normalPackage "zdbsp";
    strife       = normalPackage "strife-ve";
    asar         = normalPackage "asar";

    # Development versions of packages
    odamexMaster        = devPackage "odamex";
    eternityMaster      = devPackage "eternity-engine";
    chocolateDoomMaster = devPackage "chocolate-doom";
    nestopiaMaster      = devPackage "nestopia";
    mgbaMaster          = devPackageC libsForQt5 "mgba" {};

    wineStaging = self.winePackages.full.override {
      wineRelease = "staging";
      wineBuild = "wineWow";
    };

    winetricks = self.winetricks.override {
      wine = wineStaging;
    };

    # Package overrides
    ffmpeg      = self.ffmpeg-full.override {
#                                             enableLto        = true;
                                              nonfreeLicensing = true;
                                              alsaLib          = pkgs.alsaLib;
                                              fdkaacExtlib     = true;
                                              fdk_aac          = pkgs.fdk_aac;
                                              lame             = pkgs.lame;
                                              libogg           = pkgs.libogg;
                                              libopus          = pkgs.libopus;
                                              libass           = pkgs.libass;
                                              libvpx           = pkgs.libvpx;
                                              libva            = pkgs.libva;
                                              libvdpau         = pkgs.libvdpau;
                                              libvorbis        = pkgs.libvorbis;
                                              libpulseaudio    = pkgs.libpulseaudio;
                                              lzma             = pkgs.xz;
                                              nvenc            = true;
                                              nvidia-video-sdk = pkgs.nvidia-video-sdk;
                                              x264             = pkgs.x264;
                                              x265             = pkgs.x265;
                                              zlib             = pkgs.zlib;
                                              SDL2             = pkgs.SDL2;
                                           };
    SDL_mixer   = self.SDL_mixer.override   { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
    SDL2_mixer  = self.SDL2_mixer.override  { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
    obs-studio  = self.obs-studio.override  { pulseaudioSupport = true; };
    reposurgeon = self.reposurgeon.override { subversion = pkgs.subversion; };
  };
}
