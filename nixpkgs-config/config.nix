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
  normalPackageC = s: p: v: s.callPackage (normalProjectDir + p) v;

  # Custom dev package function
  devPackage = p: callPackage (normalProjectDir + p + "/master.nix") {};
  devPackageC = s: p: v: s.callPackage (normalProjectDir + p + "/master.nix") v;

in
{ allowUnfree = true;
  ffmpeg.x11grab = true;
  packageOverrides = self: rec {
    # Define own GHC HEAD package pointing to local checkout.
    packages_ghcHEAD = self.haskell.packages {
      ghcPath = /home/cray/ghc;
      ghcBinary = self.haskellPackages.ghcPlain;
      prefFun = self.haskell.ghcHEADPrefs;
      extraArgs = {
        happy = pkgs.haskellPackages_ghc783.happy;
        alex = pkgs.haskellPackages_ghc783.alex;
      };
    };

    # Define different GHC HEAD configurations.
    haskellPackages_ghcHEAD = recurseIntoAttrs packages_ghcHEAD.highPrio;
    haskellPackages_ghcHEAD_profiling = recurseIntoAttrs packages_ghcHEAD.profiling;
    haskellPackages_ghcHEAD_no_profiling = recurseIntoAttrs packages_ghcHEAD.noProfiling;

    # Haskell packages I want to use that reside out of nixpkgs or don't
    # have the settings I want.
    ownHaskellPackages = ver : recurseIntoAttrs (ver.override {
      extension = se : su : rec {
        xmonad 	     	= haskellPackage se "xmonad";
        xmonadContrib	= haskellPackage se "xmonad-contrib";
        SDL2		= se.callPackage /home/cray/hsSDL2 {};
      };
    });

    # Derive package sets for every version of GHC I'm interested in.
    myHaskellPackages_ghc783 = ownHaskellPackages haskellPackages_ghc783;
    myHaskellPackages_ghc783_profiling =
      ownHaskellPackages haskellPackages_ghc783_profiling;

    myHaskellPackages = myHaskellPackages_ghc783;
    myHaskellPackages_profiling = myHaskellPackages_ghc783_profiling;

    # Packages that aren't Haskell packages.
    sixpair = normalPackage "sixpair";
    zandronum = normalPackage "zandronum";
    fmod_4_24_16 = normalPackage "fmod";
    reposurgeon = normalPackage "reposurgeon";

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
