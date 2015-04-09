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
        xmonad 	     	 = haskellPackage se "xmonad";
        xmonad-contrib	 = haskellPackage se "xmonad-contrib";
        xmobar           = haskellPackage se "xmobar";
        # my irc bot
        divebot          = haskellPackage se "divebot";
        # latest cabal2nix from git needed for GHC 7.10.x
        cabal2nix        = self.callPackage /home/cray/cabal2nix/release.nix {};
        deepseq-generics = doJailbreak su.deepseq-generics;
        primitive        = doJailbreak su.primitive;
        total            = doJailbreak su.total;
        timezone-series  = doJailbreak su.timezone-series;
        timezone-olson   = doJailbreak su.timezone-olson;
        cereal-text      = doJailbreak su.cereal-text;
        c2hs             = dontCheck su.c2hs;
        text-show        = dontCheck su.text-show;
        libmpd           = appendPatch su.libmpd "/home/cray/nix-projects/haskell-projects/ghc-7.10-patches/libmpd-derive-applicative.patch";
        shake            = appendPatch su.shake  "/home/cray/nix-projects/haskell-projects/ghc-7.10-patches/shake-applicative-fix.patch";
      };
    });

    # Derive package sets for every version of GHC I'm interested in.

    myHaskellPackages = ownHaskellPackages haskellngPackages_ghc7101;

    haskellngPackages_ghc7101 = pkgs.haskell-ng.packages.ghc7101.override {
      overrides = config.haskellPackageOverrides or (self: super: {});
      provideOldAttributeNames = false;
    };

    haskellEnv = myHaskellPackages.ghcWithPackages (p: with p; [
      attoparsec parsec aeson mtl transformers lens lens-aeson
      text random vector stm comonad free total network HTTP
      QuickCheck deepseq deepseq-generics hspec optparse-applicative
      bytestring pipes turtle foldl cereal OpenGL GLUT
      hlint cabal-install hoogle yesod yesod-bin djinn alex happy
      xmonad xmonad-contrib xmobar
    ]);

    # Packages that aren't Haskell packages.
    sixpair = normalPackage "sixpair";
    zandronum = normalPackage "zandronum";
    fmod_4_24_16 = normalPackage "fmod";
    reposurgeon = normalPackage "reposurgeon";
    doom64ex = normalPackage "doom64ex";
    wadgen = normalPackage "wadgen";

    # Development versions of packages
    odamexMaster = devPackage "odamex";
    eternityMaster = devPackage "eternity-engine";
    chocolateDoomMaster = devPackage "chocolate-doom";
    restrife = devPackage "restrife";
    nestopiaMaster = devPackage "nestopia";

    # Package overrides
    SDL_mixer = self.SDL_mixer.override { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
  };
}
