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
        xmonad 	     	= haskellPackage se "xmonad";
        xmonad-contrib	= haskellPackage se "xmonad-contrib";
        xmobar          = haskellPackage se "xmobar";
        # requires base < 4.8
        dataenc         = doJailbreak su.dataenc;
        setlocale       = doJailbreak su.setlocale;
        # requires time <= 1.5
        timezone-series = doJailbreak su.timezone-series;
        timezone-olson  = doJailbreak su.timezone-olson;
        # various GHC 7.10.x patches
        hashed-storage  = appendPatch su.hashed-storage "/home/cray/nix-projects/haskell-projects/ghc-7.10-patches/hashed-storage-flexiblec.patch";
        libmpd          = appendPatch su.libmpd "/home/cray/nix-projects/haskell-projects/ghc-7.10-patches/libmpd-time-update.patch";
        foldl           = appendPatch su.foldl "/home/cray/nix-projects/haskell-projects/ghc-7.10-patches/foldl-prelude-hiding.patch";
        # latest cabal2nix from git needed for GHC 7.10.x
        cabal2nix       = self.callPackage /home/cray/cabal2nix/release.nix {};
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
      bytestring pipes turtle foldl
      cabal2nix hlint cabal-install hoogle
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
    dolphinEmuMaster = devPackageC self "dolphin-emu" { pulseaudio = pkgs.pulseaudio; };

    # Package overrides
    SDL_mixer = self.SDL_mixer.override { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
  };
}
