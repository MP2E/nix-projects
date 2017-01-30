{ pkgs }:

with import ../../nixpkgs/pkgs/development/haskell-modules/lib.nix { inherit pkgs; };
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
  normalPackageC = s: p: v: s.callPackage (normalProjectDir + p) v;

  # Custom dev package function
  devPackage = p: callPackage (normalProjectDir + p + "/master.nix") {};
  devPackageC = s: p: v: s.callPackage (normalProjectDir + p + "/master.nix") v;

in
{ allowUnfree = true;
  ffmpeg.x11grab = true;
  packageOverrides = self: rec {
    # Haskell packages I want to use that reside out of nixpkgs or don't
    # have the settings I want.
    ownHaskellPackages = ver : recurseIntoAttrs (ver.override {
      overrides = se : su : rec {
        divebot          = haskellPackage se "divebot";
        # needed for xmonad master
        X11              = su.X11_1_7;
        xmonad           = haskellPackage se "xmonad";
        xmonad-contrib   = haskellPackage se "xmonad-contrib";
        cabal-helper     = doJailbreak su.cabal-helper;
        total            = doJailbreak su.total;
        turtle           = doJailbreak su.turtle;
      };
    });

    # Derive package sets for the versions of GHC I'm interested in.
    myHaskellPackages = ownHaskellPackages pkgs.haskell.packages.ghc802;

    haskellEnv = myHaskellPackages.ghcWithPackages (p: with p; [
      attoparsec parsec aeson mtl transformers lens lens-aeson
      text random vector stm comonad free total network HTTP
      QuickCheck deepseq deepseq-generics hspec optparse-applicative
      bytestring pipes turtle foldl cereal OpenGL GLUT
      hlint cabal-install hoogle yesod yesod-bin djinn alex happy
      # ghci-ng ghc-mod stylish-haskell
      xmonad xmonad-contrib xmobar
    ]);

    jsEnv = haskell.packages.ghcjs.ghcWithPackages (p: with p; [
      reflex reflex-dom ghcjs-dom
    ]);

    # Packages that aren't Haskell packages.
    sixpair      = normalPackage "sixpair";
    doom64ex     = normalPackage "doom64ex";
    wadgen       = normalPackage "wadgen";
    slade        = normalPackage "slade";
    zdbsp        = normalPackage "zdbsp";

    # Development versions of packages
    odamexMaster        = devPackage "odamex";
    eternityMaster      = devPackage "eternity-engine";
    chocolateDoomMaster = devPackage "chocolate-doom";
    nestopiaMaster      = devPackage "nestopia";

    # Package overrides
    ffmpeg     = self.ffmpeg-full.override {
                                              nonfreeLicensing = true;
                                              alsaLib          = pkgs.alsaLib;
                                              fdkaacExtlib     = true;
                                              fdk_aac          = pkgs.fdk_aac;
                                              lame             = pkgs.lame;
                                              libogg           = pkgs.libogg;
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
                                            };
    SDL_mixer  = self.SDL_mixer.override   { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
    obs-studio = self.obs-studio.override  { pulseaudioSupport = true; };
  };
}
