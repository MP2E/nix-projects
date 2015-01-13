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
    # Haskell packages I want to use that reside out of nixpkgs or don't
    # have the settings I want.
    ownHaskellPackages = ver : recurseIntoAttrs (ver.override {
      overrides = se : su : rec {
        xmonad 	     	= haskellPackage se "xmonad";
        xmonad-contrib	= haskellPackage se "xmonad-contrib";
      };
    });

    # Derive package sets for every version of GHC I'm interested in.
    # TODO: add profiling for haskell-ng
    myHaskellPackages = ownHaskellPackages haskellngPackages;

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
