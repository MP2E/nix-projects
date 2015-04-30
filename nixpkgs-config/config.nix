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
        xmobar           = haskellPackageC se "xmobar" { Xrender = null;  inherit (pkgs.xlibs) libXpm; inherit (pkgs.xlibs) libXrandr;  inherit (pkgs) wirelesstools;};
        ghc-mod          = dontCheck (haskellPackage se "ghc-mod");
        ghci-ng          = haskellPackage se "ghci-ng";
        cabal-helper     = haskellPackage se "cabal-helper";
        # my irc bot
        divebot          = haskellPackage se "divebot";
        holydivebot      = haskellPackage se "holydivebot";
        # GHC 7.10.1 needs these to be jailbroken
        total            = doJailbreak su.total;
        cereal-text      = doJailbreak su.cereal-text;
      };
    });

    # Derive package sets for every version of GHC I'm interested in.

    myHaskellPackages = ownHaskellPackages pkgs.haskellngPackages;

    haskellEnv = myHaskellPackages.ghcWithPackages (p: with p; [
      attoparsec parsec aeson mtl transformers lens lens-aeson
      text random vector stm comonad free total network HTTP
      QuickCheck deepseq deepseq-generics hspec optparse-applicative
      bytestring pipes turtle foldl cereal OpenGL GLUT
      hlint cabal-install hoogle yesod yesod-bin djinn alex happy
      ghci-ng ghc-mod stylish-haskell cabal2nix
      xmonad xmonad-contrib xmobar darcs
    ]);

    # Packages that aren't Haskell packages.
    sixpair      = normalPackage "sixpair";
    zandronum    = normalPackage "zandronum";
    fmod_4_24_16 = normalPackage "fmod";
    reposurgeon  = normalPackage "reposurgeon";
    doom64ex     = normalPackage "doom64ex";
    wadgen       = normalPackage "wadgen";
    slade        = normalPackage "slade";
    zdbsp        = normalPackage "zdbsp";

    # Development versions of packages
    odamexMaster        = devPackage "odamex";
    eternityMaster      = devPackage "eternity-engine";
    chocolateDoomMaster = devPackage "chocolate-doom";
    restrife            = devPackage "restrife";
    nestopiaMaster      = devPackage "nestopia";

    # Package overrides
    SDL_mixer = self.SDL_mixer.override { enableNativeMidi = true; fluidsynth = pkgs.fluidsynth; };
  };
}
